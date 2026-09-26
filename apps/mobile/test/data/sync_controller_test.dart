import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/data/database.dart';
import 'package:playlink/data/providers.dart';
import 'package:playlink/data/sync_controller.dart';

/// Couvre le contrat du contrôleur de synchro : la séquence « synchroniser
/// puis rafraîchir » doit aboutir quel que soit le sort de l'appelant.
///
/// `syncAccount` est remplacé par `syncAccountOverrideProvider` — le vrai
/// appel exige un `ClerkAuthState` (classe concrète du SDK, non simulable) et
/// partirait sur le réseau.
void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  /// Construit un conteneur dont la synchro renvoie [result], en comptant les
  /// appels réellement effectués.
  ({ProviderContainer container, List<int> calls}) build({
    required bool result,
    Completer<void>? gate,
  }) {
    final calls = <int>[];
    container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(db),
      syncAccountOverrideProvider.overrideWithValue(() async {
        calls.add(1);
        if (gate != null) await gate.future;
        return result;
      }),
    ]);
    return (container: container, calls: calls);
  }

  test('succès : rafraîchit les joueurs et les listes, état success', () async {
    final h = build(result: true);

    await db.into(db.localPlayers).insert(LocalPlayersCompanion.insert(
          id: 'p1',
          name: 'Lina',
          avatar: '🦊',
          createdAt: DateTime.now(),
        ));

    final ok = await h.container.read(syncControllerProvider.notifier).sync(null);

    expect(ok, isTrue);
    expect(h.container.read(syncControllerProvider), SyncStatus.success);
    // `load()` a bien été appelé : le joueur inséré hors du notifier apparaît.
    expect(h.container.read(playersProvider).map((p) => p.name), ['Lina']);
  });

  test('échec : invalide quand même, état failure, joueurs non rechargés', () async {
    final h = build(result: false);
    await h.container.read(playersProvider.notifier).load();

    await db.into(db.localPlayers).insert(LocalPlayersCompanion.insert(
          id: 'p1',
          name: 'Lina',
          avatar: '🦊',
          createdAt: DateTime.now(),
        ));

    final ok = await h.container.read(syncControllerProvider.notifier).sync(null);

    expect(ok, isFalse);
    expect(h.container.read(syncControllerProvider), SyncStatus.failure);
    // Pas de `load()` en échec : l'état en mémoire n'a pas bougé.
    expect(h.container.read(playersProvider), isEmpty);
  });

  test('deux appels concurrents ne déclenchent qu\'une synchro', () async {
    final gate = Completer<void>();
    final h = build(result: true, gate: gate);
    final notifier = h.container.read(syncControllerProvider.notifier);

    final first = notifier.sync(null);
    final second = notifier.sync(null);
    expect(h.container.read(syncControllerProvider), SyncStatus.syncing);

    gate.complete();
    expect(await first, isTrue);
    expect(await second, isTrue);
    expect(h.calls, hasLength(1));
  });

  test('une synchro relancée après la précédente repart bien', () async {
    final h = build(result: true);
    final notifier = h.container.read(syncControllerProvider.notifier);

    await notifier.sync(null);
    await notifier.sync(null);

    expect(h.calls, hasLength(2));
  });

  test('non-régression : le rafraîchissement survit au démontage de l\'appelant',
      () async {
    // Reproduit le bug d'origine : l'écran de connexion lance la synchro sans
    // l'attendre puis navigue, ce qui le démonte. Avec la logique portée par un
    // widget, le rafraîchissement était perdu ; portée par le contrôleur, dont
    // le `ref` appartient au conteneur, elle doit aboutir.
    final gate = Completer<void>();
    final h = build(result: true, gate: gate);

    // Un consommateur éphémère lance la synchro, puis disparaît — comme
    // l'écran de connexion après `context.go('/profile')`.
    final ephemeral = h.container.listen(
      syncControllerProvider,
      (_, _) {},
    );
    final future = h.container.read(syncControllerProvider.notifier).sync(null);
    ephemeral.close();

    await db.into(db.localPlayers).insert(LocalPlayersCompanion.insert(
          id: 'p1',
          name: 'Lina',
          avatar: '🦊',
          createdAt: DateTime.now(),
        ));

    gate.complete();
    expect(await future, isTrue);

    // Le rafraîchissement a bien eu lieu malgré la disparition de l'appelant.
    expect(h.container.read(playersProvider).map((p) => p.name), ['Lina']);
    expect(h.container.read(syncControllerProvider), SyncStatus.success);
  });
}
