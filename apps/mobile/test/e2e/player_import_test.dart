import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/data/database.dart';
import 'package:playlink/data/providers.dart';

/// Vérifie le flux d'import d'un profil existant, en pilotant directement
/// `PlayersNotifier` — sans UI. Le comportement de l'écran (feuille
/// import/renommer déclenchée au clic sur +) est un simple aiguillage sur
/// ces mêmes méthodes ; c'est la logique qui compte le plus à couvrir de
/// façon fiable, l'UI étant vérifiée visuellement par ailleurs.
void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late PlayersNotifier notifier;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    notifier = container.read(playersProvider.notifier);
    await notifier.load();
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('un profil retiré de la session est retrouvé par findByName', () async {
    await notifier.create('Lina');
    final lina = notifier.inSession.single;

    await notifier.applyGameResult(
      sessionScores: {lina.id: 12},
      cumulativeTagScores: {lina.id: {'humour': 3}},
    );

    await notifier.remove(lina.id);
    expect(notifier.inSession, isEmpty,
        reason: 'retirée de la session, elle ne doit plus y apparaître');

    // Toujours en base (historique conservé), juste plus en session.
    final all = await (db.select(db.localPlayers)).get();
    expect(all, hasLength(1));
    expect(all.single.totalScore, 12);
    expect(all.single.inSession, isFalse);

    final found = notifier.findByName('lina'); // insensible à la casse
    expect(found, isNotNull);
    expect(found!.totalScore, 12,
        reason: 'les stats doivent suivre le profil retrouvé, pas repartir de zéro');
    expect(found.gamesPlayed, 1);
  });

  test('import ramène le même profil, sans doublon en base', () async {
    await notifier.create('Lina');
    final lina = notifier.inSession.single;
    await notifier.applyGameResult(
      sessionScores: {lina.id: 12},
      cumulativeTagScores: {lina.id: {}},
    );
    await notifier.remove(lina.id);
    expect(notifier.inSession, isEmpty);

    final found = notifier.findByName('Lina')!;
    await notifier.import(found.id);

    expect(notifier.inSession, hasLength(1));
    expect(notifier.inSession.single.name, 'Lina');
    expect(notifier.inSession.single.totalScore, 12,
        reason: 'l\'import ne doit pas remettre le score à zéro');

    final all = await (db.select(db.localPlayers)).get();
    expect(all.where((p) => p.name == 'Lina'), hasLength(1),
        reason: 'importer ne doit jamais créer de doublon en base');
  });

  test('create() refuse un nom déjà en session, avec un profil hors session il crée quand même', () async {
    await notifier.create('Lina');

    // Doublon réel : deux joueurs, même prénom, même soir.
    final err = await notifier.create('lina'); // insensible à la casse
    expect(err, AddPlayerError.alreadyInSession);
    expect(notifier.inSession, hasLength(1));

    // Un même nom mais retiré de la session n'est PAS un obstacle pour
    // `create` seule : c'est l'écran qui doit détecter ce cas via
    // `findByName` et proposer l'import AVANT d'appeler `create`. Il faut
    // un profil avec historique pour que `remove` le désactive plutôt que
    // de le supprimer, sinon ce test ne couvrirait rien de plus que la
    // suppression déjà vérifiée ailleurs.
    final active = notifier.inSession.single;
    await notifier.applyGameResult(sessionScores: {active.id: 3}, cumulativeTagScores: {active.id: {}});
    await notifier.remove(active.id);
    expect(notifier.findByName('Lina'), isNotNull, reason: 'désactivée, pas supprimée : elle a un historique');

    final err2 = await notifier.create('Lina');
    expect(err2, isNull);
    final all = await (db.select(db.localPlayers)).get();
    expect(all, hasLength(2),
        reason:
            'create() seule ne fait pas le matching — c\'est l\'écran qui doit appeler findByName avant, sinon deux profils "Lina" coexistent');
  });

  test('findByName ignore la casse et les espaces superflus', () async {
    await notifier.create('Lina');
    await notifier.setInSession(notifier.inSession.single.id, false);

    expect(notifier.findByName('LINA'), isNotNull);
    expect(notifier.findByName('  Lina  '), isNotNull);
    expect(notifier.findByName('Lin'), isNull);
  });
}
