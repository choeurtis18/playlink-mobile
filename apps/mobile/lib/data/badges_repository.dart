import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/badges.dart';
import 'database.dart';

/// Un badge de contenu (métadonnées, traduites) avec son état sur
/// l'appareil — pour l'écran D4.
class BadgeVm {
  const BadgeVm({
    required this.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.earned,
    required this.earnedAt,
  });
  final String key, name, description, icon;
  final bool earned;
  final DateTime? earnedAt;
}

class BadgesRepository {
  BadgesRepository(this.db);
  final AppDatabase db;

  Future<Set<String>> earnedKeys() async {
    final rows = await db.select(db.earnedBadges).get();
    return rows.map((r) => r.badgeKey).toSet();
  }

  /// Grille pour l'écran D4 : tous les badges de contenu, dans leur ordre,
  /// avec leur état (débloqué + date, ou verrouillé).
  Future<List<BadgeVm>> all(String locale) async {
    final defs = await (db.select(db.badges)..orderBy([(b) => OrderingTerm.asc(b.sortOrder)])).get();
    final earned = {for (final r in await db.select(db.earnedBadges).get()) r.badgeKey: r.earnedAt};
    return [
      for (final b in defs)
        BadgeVm(
          key: b.key,
          name: _localized(b.translationsJson, locale, 'name') ?? b.name,
          description: _localized(b.translationsJson, locale, 'description') ?? b.description,
          icon: b.icon,
          earned: earned.containsKey(b.key),
          earnedAt: earned[b.key],
        ),
    ];
  }

  String? _localized(String? translationsJson, String locale, String field) {
    if (translationsJson == null || locale == 'fr') return null;
    final map = jsonDecode(translationsJson) as Map;
    final tr = map[locale] as Map?;
    return tr?[field] as String?;
  }

  /// Charge tout l'historique en `BadgeContext`, une ligne par (session,
  /// joueur) — reconstruit `isWinner` (meilleur score DE la partie) et
  /// `tagsGained` (une entrée par occurrence, depuis le cumul par partie)
  /// à partir de ce qui est déjà en base.
  Future<BadgeContext> _loadContext() async {
    final players = await db.select(db.localPlayers).get();
    final totalScore = players.fold(0, (s, p) => s + p.totalScore);
    final gamesPlayed = players.fold(0, (s, p) => s + p.gamesPlayed);

    final sessions = await db.select(db.gameSessions).get();
    final sessionPlayers = await db.select(db.sessionPlayers).get();
    final bySession = <String, List<SessionPlayer>>{};
    for (final sp in sessionPlayers) {
      bySession.putIfAbsent(sp.sessionId, () => []).add(sp);
    }

    final records = <BadgeGameRecord>[];
    for (final s in sessions) {
      final rows = bySession[s.id] ?? const [];
      if (rows.isEmpty) continue;
      final best = rows.map((r) => r.score).reduce((a, b) => a > b ? a : b);
      for (final row in rows) {
        final tags = (jsonDecode(row.tagScoresGainedJson) as Map).cast<String, int>();
        final tagsGained = <String>[
          for (final entry in tags.entries) for (var i = 0; i < entry.value; i++) entry.key,
        ];
        records.add(BadgeGameRecord(
          gameId: s.gameId,
          locale: s.locale,
          playerCount: s.playerCount,
          finishedAt: s.finishedAt,
          playerId: row.playerId,
          score: row.score,
          isWinner: row.score == best,
          tagsGained: tagsGained,
        ));
      }
    }

    final customCardsCreated = await db.customCards.count().getSingle();

    return BadgeContext(
      totalScore: totalScore,
      gamesPlayed: gamesPlayed,
      records: records,
      customCardsCreated: customCardsCreated,
      // Pas encore construit (Phase 4, compte requis) : `curator` reste
      // verrouillé tant que les likes n'existent pas.
      likedCardsCount: 0,
    );
  }

  /// B6 : à appeler après la persistance d'une partie. Renvoie les clés
  /// NOUVELLEMENT débloquées par cette évaluation (pour une modale de
  /// félicitations) — idempotent, sûr à rappeler.
  Future<Set<String>> checkAndAward() async {
    final already = await earnedKeys();
    final ctx = await _loadContext();
    final unlocked = evaluateBadges(ctx, already);
    final newlyEarned = unlocked.difference(already);
    if (newlyEarned.isEmpty) return newlyEarned;

    final now = DateTime.now();
    await db.batch((b) {
      for (final key in newlyEarned) {
        b.insert(
          db.earnedBadges,
          EarnedBadgesCompanion.insert(badgeKey: key, earnedAt: now),
        );
      }
    });
    return newlyEarned;
  }
}
