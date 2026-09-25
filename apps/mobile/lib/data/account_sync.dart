import 'dart:convert';

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import 'database.dart';

/// URL du back-office (Next.js). Fournie au build via
/// `--dart-define=BACKOFFICE_URL=https://...` — en dev, pointe vers l'API
/// locale (`next dev`) ou le déploiement Vercel de test.
const _backofficeUrl = String.fromEnvironment(
  'BACKOFFICE_URL',
  defaultValue: 'http://localhost:3000',
);

/// Crée (ou retrouve) l'`Account` Prisma correspondant au joueur connecté,
/// puis merge tout l'historique local (profils, parties, badges, cartes
/// perso — §05, phase 4) vers le back-office.
///
/// Best-effort, jamais bloquant : hors-ligne ou back-office indisponible,
/// l'app reste utilisable normalement (§01, offline-first) — la synchro se
/// retentera à la prochaine connexion. Rejouable sans effet de bord (voir
/// `POST /api/sync`, idempotent sur localId/clientSessionId/badgeKey).
Future<void> syncAccount(ClerkAuthState authState, AppDatabase db) async {
  if (!authState.isSignedIn) return;
  try {
    final token = await authState.sessionToken();
    final headers = {
      'Authorization': 'Bearer ${token.jwt}',
      'Content-Type': 'application/json',
    };

    await http
        .post(Uri.parse('$_backofficeUrl/api/account'), headers: headers)
        .timeout(const Duration(seconds: 10));

    await _syncGameData(db, headers);
  } catch (_) {
    // Best-effort — voir docstring. Pas de remontée d'erreur à l'UI.
  }
}

Future<void> _syncGameData(AppDatabase db, Map<String, String> headers) async {
  final players = await db.select(db.localPlayers).get();
  final sessions = await db.select(db.gameSessions).get();
  final sessionPlayers = await db.select(db.sessionPlayers).get();
  final badges = await db.select(db.earnedBadges).get();
  // Seulement les cartes jamais encore envoyées — `POST /api/sync` crée
  // toujours une nouvelle ligne côté back-office, renvoyer une carte déjà
  // synchronisée créerait un doublon à chaque connexion.
  final customCards = await (db.select(db.customCards)..where((c) => c.remoteId.isNull())).get();

  if (players.isEmpty && sessions.isEmpty && badges.isEmpty && customCards.isEmpty) return;

  final byPlayer = <String, List<SessionPlayer>>{};
  for (final sp in sessionPlayers) {
    byPlayer.putIfAbsent(sp.sessionId, () => []).add(sp);
  }

  final payload = {
    'profiles': [
      for (final p in players)
        {
          'localId': p.id,
          'name': p.name,
          'avatar': p.avatar,
          'tagScores': jsonDecode(p.tagScoresJson),
        },
    ],
    'sessions': [
      for (final s in sessions)
        {
          'clientSessionId': s.id,
          'gameId': s.gameId,
          'categoryId': s.categoryId,
          'locale': s.locale,
          'playerCount': s.playerCount,
          'startedAt': s.startedAt.toIso8601String(),
          'finishedAt': s.finishedAt.toIso8601String(),
          'players': [
            for (final sp in byPlayer[s.id] ?? const <SessionPlayer>[])
              {
                'profileLocalId': sp.playerId,
                'score': sp.score,
                'tagScoresGained': jsonDecode(sp.tagScoresGainedJson),
              },
          ],
        },
    ],
    'badges': [
      for (final b in badges) {'badgeKey': b.badgeKey, 'earnedAt': b.earnedAt.toIso8601String()},
    ],
    'customCards': [
      for (final c in customCards)
        {
          'localId': c.id,
          'gameId': c.gameId,
          'categoryId': c.categoryId,
          'text': c.text_,
          'intensity': c.intensity,
          'active': c.active,
        },
    ],
  };

  final response = await http
      .post(Uri.parse('$_backofficeUrl/api/sync'), headers: headers, body: jsonEncode(payload))
      .timeout(const Duration(seconds: 20));
  if (response.statusCode != 200) return;

  final body = jsonDecode(response.body) as Map<String, dynamic>;
  final profileRemoteIds = (body['profileRemoteIds'] as Map).cast<String, String>();
  final cardRemoteIds = (body['cardRemoteIds'] as Map).cast<String, String>();
  final now = DateTime.now();

  await db.batch((b) {
    for (final entry in profileRemoteIds.entries) {
      b.update(
        db.localPlayers,
        LocalPlayersCompanion(remoteId: Value(entry.value)),
        where: (p) => p.id.equals(entry.key),
      );
    }
    for (final s in sessions) {
      b.update(
        db.gameSessions,
        GameSessionsCompanion(syncedAt: Value(now)),
        where: (x) => x.id.equals(s.id),
      );
    }
    for (final bdg in badges) {
      b.update(
        db.earnedBadges,
        EarnedBadgesCompanion(syncedAt: Value(now)),
        where: (x) => x.badgeKey.equals(bdg.badgeKey),
      );
    }
    for (final entry in cardRemoteIds.entries) {
      b.update(
        db.customCards,
        CustomCardsCompanion(remoteId: Value(entry.value), syncedAt: Value(now)),
        where: (c) => c.id.equals(entry.key),
      );
    }
  });
}
