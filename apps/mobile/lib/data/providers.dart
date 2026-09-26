import 'dart:convert';
import 'dart:math';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/deck.dart';
import 'badges_repository.dart';
import 'content_repository.dart';
import 'content_seeder.dart';
import 'custom_cards_repository.dart';
import 'database.dart';

/// Identifiant local : 128 bits aléatoires en hex. Sert de `localId` lors du
/// merge vers le cloud (§05), il doit donc être stable et unique.
String newId() {
  final r = Random.secure();
  return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(driftDatabase(name: 'playlink'));
  ref.onDispose(db.close);
  return db;
});

final contentRepositoryProvider =
    Provider<ContentRepository>((ref) => ContentRepository(ref.watch(databaseProvider)));

final badgesRepositoryProvider =
    Provider<BadgesRepository>((ref) => BadgesRepository(ref.watch(databaseProvider)));

final customCardsRepositoryProvider =
    Provider<CustomCardsRepository>((ref) => CustomCardsRepository(ref.watch(databaseProvider)));

// `autoDispose` : sans lui, ce provider ne se recalcule JAMAIS une fois lu
// une première fois (ex. un tour de curiosité sur cet écran avant de
// jouer) — l'écran resterait figé sur « tout verrouillé » pour le reste
// de la session, même après un badge réellement débloqué en base.
final badgesListProvider = FutureProvider.autoDispose<List<BadgeVm>>((ref) {
  final locale = ref.watch(localeProvider).languageCode;
  return ref.watch(badgesRepositoryProvider).all(locale);
});

final myCardsListProvider = FutureProvider<List<CustomCardVm>>((ref) {
  return ref.watch(customCardsRepositoryProvider).all();
});

// ─── Préférences ─────────────────────────────────────────────────────

class PrefKeys {
  PrefKeys._();
  static const locale = 'locale';
  static const cardsPerGame = 'cardsPerGame';
  static const themeMode = 'themeMode';
  static const onboardingSeen = 'onboardingSeen';
  static const analyticsConsent = 'analyticsConsent';
  static const accountState = 'accountState';
  static String intensity(String gameId) => 'intensity:$gameId';
}

/// Façade de démo tant que Clerk/RevenueCat ne sont pas construits (§ V1
/// "préparé, pas construit" — CLAUDE.md) : purement locale, ne représente
/// aucun vrai compte ni abonnement.
enum AccountState { guest, free, premium }

class PrefsNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  Future<void> load() async {
    final db = ref.read(databaseProvider);
    final rows = await db.select(db.appPrefs).get();
    state = {for (final r in rows) r.key: r.value};
  }

  Future<void> set(String key, String value) async {
    final db = ref.read(databaseProvider);
    await db.into(db.appPrefs).insertOnConflictUpdate(
          AppPrefsCompanion(key: Value(key), value: Value(value)),
        );
    state = {...state, key: value};
  }
}

final prefsProvider =
    NotifierProvider<PrefsNotifier, Map<String, String>>(PrefsNotifier.new);

extension PrefsView on Map<String, String> {
  /// Intensité mémorisée par jeu (B2), défaut 3.
  int intensityFor(String gameId) =>
      int.tryParse(this[PrefKeys.intensity(gameId)] ?? '') ?? intensityDefault;
  int get cardsPerGame =>
      int.tryParse(this[PrefKeys.cardsPerGame] ?? '') ?? cardsPerGameDefault;
  bool get onboardingSeen => this[PrefKeys.onboardingSeen] == '1';
  String get themeMode => this[PrefKeys.themeMode] ?? 'dark';
  bool? get analyticsConsent => switch (this[PrefKeys.analyticsConsent]) {
        '1' => true,
        '0' => false,
        _ => null,
      };
  AccountState get accountState => switch (this[PrefKeys.accountState]) {
        'free' => AccountState.free,
        'premium' => AccountState.premium,
        _ => AccountState.guest,
      };
}

/// Langue effective : préférence explicite, sinon celle du système,
/// ramenée à FR ou EN (les seules langues de contenu).
final localeProvider = Provider<Locale>((ref) {
  final override = ref.watch(prefsProvider)[PrefKeys.locale];
  if (override == 'fr' || override == 'en') return Locale(override!);
  final sys = PlatformDispatcher.instance.locale.languageCode;
  return Locale(sys == 'en' ? 'en' : 'fr');
});

// ─── Joueurs ─────────────────────────────────────────────────────────

const avatarPool = [
  '🦊', '⚡', '🎯', '🌟', '🐯', '🎪', '🦋', '🐸', '🐼', '🦁',
  '🐙', '🍕', '🐨', '🦄', '🐢', '🦖', '🍩', '🎮', '🚀', '🌈',
];

enum AddPlayerError { empty, alreadyInSession }

/// Édition du nom/emoji d'un profil existant (voir `PlayersEditor`).
enum UpdatePlayerError { empty, nameTaken }

class PlayersNotifier extends Notifier<List<LocalPlayer>> {
  @override
  List<LocalPlayer> build() => const [];

  AppDatabase get _db => ref.read(databaseProvider);

  Future<void> load() async {
    state = await (_db.select(_db.localPlayers)
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder), (p) => OrderingTerm.asc(p.createdAt)]))
        .get();
  }

  /// La liste de session : ceux qui jouent ce soir (A1/A2/B1). Seule liste
  /// affichée à l'écran — les autres profils de l'appareil restent en
  /// arrière-plan (matching de nom, alimentation du classement).
  List<LocalPlayer> get inSession => state.where((p) => p.inSession).toList();

  /// Profil existant (tous appareil confondus) dont le nom correspond,
  /// insensible à la casse — pour proposer import/renommage avant création.
  LocalPlayer? findByName(String rawName) {
    final name = rawName.trim().toLowerCase();
    if (name.isEmpty) return null;
    for (final p in state) {
      if (p.name.toLowerCase() == name) return p;
    }
    return null;
  }

  /// Crée un nouveau profil. Le nom doit être unique parmi les joueurs
  /// EN SESSION (deux personnes ne peuvent pas jouer sous le même nom le
  /// même soir) ; un nom qui correspond à un profil non-actif est autorisé
  /// ici — c'est `findByName` + le choix de l'utilisateur qui filtrent ce
  /// cas en amont, côté UI.
  Future<AddPlayerError?> create(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) return AddPlayerError.empty;
    if (inSession.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      return AddPlayerError.alreadyInSession;
    }
    final used = state.map((p) => p.avatar).toSet();
    final avatar = avatarPool.firstWhere((a) => !used.contains(a), orElse: () => '👤');
    await _db.into(_db.localPlayers).insert(
          LocalPlayersCompanion.insert(
            id: newId(),
            name: name,
            avatar: avatar,
            createdAt: DateTime.now(),
            sortOrder: Value(state.length),
          ),
        );
    await load();
    return null;
  }

  /// Ramène dans la session un profil déjà enregistré sur l'appareil —
  /// aucune retype de nom, ses stats cumulées suivent.
  Future<void> import(String id) => setInSession(id, true);

  /// Modifie le nom et/ou l'emoji d'un profil existant. Le nom reste unique
  /// sur l'appareil (même contrainte qu'à la création) — comparé à tous les
  /// AUTRES profils, pas seulement ceux en session : sinon deux profils
  /// pourraient finir avec le même nom dès que l'un des deux sort de la
  /// session, cassant le matching de `findByName`.
  Future<UpdatePlayerError?> updateProfile(String id, {String? name, String? avatar}) async {
    final trimmed = name?.trim();
    if (trimmed != null) {
      if (trimmed.isEmpty) return UpdatePlayerError.empty;
      final clash = state.any((p) => p.id != id && p.name.toLowerCase() == trimmed.toLowerCase());
      if (clash) return UpdatePlayerError.nameTaken;
    }
    await (_db.update(_db.localPlayers)..where((p) => p.id.equals(id))).write(
      LocalPlayersCompanion(
        name: trimmed == null ? const Value.absent() : Value(trimmed),
        avatar: avatar == null ? const Value.absent() : Value(avatar),
      ),
    );
    await load();
    return null;
  }

  Future<void> setInSession(String id, bool value) async {
    await (_db.update(_db.localPlayers)..where((p) => p.id.equals(id)))
        .write(LocalPlayersCompanion(inSession: Value(value)));
    await load();
  }

  /// Un profil qui a déjà joué garde son historique : on le retire de la
  /// session au lieu de le supprimer.
  ///
  /// `gamesPlayed` sur le profil lui-même est la source de vérité — pas une
  /// jointure sur `sessionPlayers` (le journal détaillé des parties), qui
  /// peut être vide alors que le profil porte déjà un score cumulé (ex. un
  /// résultat appliqué sans que la ligne de session ait été écrite).
  /// Vérifier sur les deux le mettrait à la merci de leur désynchronisation ;
  /// vérifier sur le profil seul, jamais.
  Future<void> remove(String id) async {
    final player = state.where((p) => p.id == id).firstOrNull;
    final hasHistory = player != null && (player.gamesPlayed > 0 || player.totalScore > 0);
    if (hasHistory) {
      await setInSession(id, false);
    } else {
      await (_db.delete(_db.localPlayers)..where((p) => p.id.equals(id))).go();
      await load();
    }
  }

  /// Fin de partie (B6) : cumul durable des scores et des tags sur le profil.
  Future<void> applyGameResult({
    required Map<String, int> sessionScores,
    required Map<String, Map<String, int>> cumulativeTagScores,
  }) async {
    await _db.transaction(() async {
      for (final p in state) {
        final gained = sessionScores[p.id];
        if (gained == null) continue;
        await (_db.update(_db.localPlayers)..where((x) => x.id.equals(p.id))).write(
          LocalPlayersCompanion(
            totalScore: Value(p.totalScore + gained),
            gamesPlayed: Value(p.gamesPlayed + 1),
            tagScoresJson: Value(jsonEncode(cumulativeTagScores[p.id] ?? const {})),
          ),
        );
      }
    });
    await load();
  }
}

final playersProvider =
    NotifierProvider<PlayersNotifier, List<LocalPlayer>>(PlayersNotifier.new);

/// Démarrage (A1/A2) : seed du contenu si nécessaire, puis chargement des
/// préférences et des joueurs. Le splash attend ce provider.
///
/// Surchargeable en test : `rootBundle.loadString` sur le snapshot embarqué
/// (plusieurs centaines de Ko) n'aboutit jamais sous le binding par défaut
/// de `flutter test` (contrairement à un appareil réel ou un test
/// d'intégration) — les tests widget injectent donc `seed` pour appliquer
/// un snapshot déjà en mémoire, sans passer par le bundle d'assets.
final appBootProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  final seed = ref.watch(seedOverrideProvider) ?? (() => seedIfNeeded(db));
  await seed();
  await ref.read(prefsProvider.notifier).load();
  await ref.read(playersProvider.notifier).load();
});

/// null par défaut (chemin normal : `rootBundle`). Les tests le surchargent
/// pour appliquer un snapshot déjà en mémoire.
final seedOverrideProvider = Provider<Future<void> Function()?>((ref) => null);
