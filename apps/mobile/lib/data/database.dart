import 'package:drift/drift.dart';

part 'database.g.dart';

// Base locale SQLite — source de vérité pour jouer (§04).
//
// Deux familles de tables :
// - CONTENU : seedé depuis le snapshot embarqué, remplacé d'un bloc à
//   chaque mise à jour OTA. Jamais édité sur l'appareil.
// - LOCAL : joueurs, parties, préférences. Propriété de l'appareil.
//
// Les traductions sont stockées en JSON sur chaque ligne (`translationsJson`)
// plutôt qu'en tables séparées : on lit toujours une ligne entière avec sa
// langue, jamais une traduction seule. FR est le texte principal, absent du
// JSON ; une langue manquante ⇒ fallback FR (règle absolue, CLAUDE.md).

// ─── Contenu ─────────────────────────────────────────────────────────

class Games extends Table {
  TextColumn get id => text()();
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get colorMain => text()();
  TextColumn get colorSecondary => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get translationsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(Games, #id)();
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer()();
  TextColumn get tier => text().withDefault(const Constant('free'))();
  TextColumn get translationsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get text_ => text().named('text')();
  IntColumn get intensity => integer()();
  TextColumn get tagsJson => text()();
  TextColumn get canonicalTagsJson => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get tier => text().withDefault(const Constant('free'))();
  TextColumn get translationsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RuleSlides extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(Games, #id)();
  IntColumn get sortOrder => integer()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  /// `asset://{hash}.{ext}` — résolu contre ContentAssets, jamais une URL.
  TextColumn get imageRef => text().nullable()();
  TextColumn get translationsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Métadonnées seulement : la règle d'attribution est du code Dart (§01).
class Badges extends Table {
  TextColumn get key => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get icon => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get translationsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class ContentAssets extends Table {
  TextColumn get ref => text()();
  TextColumn get file => text()();
  TextColumn get hash => text()();
  IntColumn get bytes => integer()();
  TextColumn get type => text()();

  @override
  Set<Column> get primaryKey => {ref};
}

/// Une seule ligne : la version de contenu installée.
class ContentMeta extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get version => integer()();
  DateTimeColumn get installedAt => dateTime()();
  DateTimeColumn get lastCheckAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Local ───────────────────────────────────────────────────────────

/// Les joueurs de l'appareil. `inSession` + `sortOrder` composent la liste
/// de session (A1/A2/B1) ; `tagScoresJson` porte l'archétype (§01 : les
/// tags sont sur le PROFIL, pas sur le compte).
class LocalPlayers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatar => text()();
  TextColumn get tagScoresJson => text().withDefault(const Constant('{}'))();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  IntColumn get gamesPlayed => integer().withDefault(const Constant(0))();
  BoolColumn get inSession => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  /// Renseigné au merge local → cloud (phase 4).
  TextColumn get remoteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class GameSessions extends Table {
  /// uuid stable côté client : clé d'idempotence du merge (§05).
  TextColumn get id => text()();
  TextColumn get gameId => text()();
  TextColumn get categoryId => text()();
  TextColumn get locale => text()();
  IntColumn get intensity => integer()();
  IntColumn get cardsPlayed => integer()();
  IntColumn get playerCount => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SessionPlayers extends Table {
  TextColumn get sessionId => text().references(GameSessions, #id)();
  TextColumn get playerId => text().references(LocalPlayers, #id)();
  IntColumn get score => integer()();
  TextColumn get tagScoresGainedJson => text()();

  @override
  Set<Column> get primaryKey => {sessionId, playerId};
}

/// Clé/valeur : langue UI, intensité par jeu, cartes/partie, thème,
/// onboarding vu, consentement analytics.
class AppPrefs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  Games, Categories, Cards, RuleSlides, Badges, ContentAssets, ContentMeta,
  LocalPlayers, GameSessions, SessionPlayers, AppPrefs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
