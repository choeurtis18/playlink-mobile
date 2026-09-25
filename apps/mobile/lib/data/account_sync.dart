import 'dart:convert';

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import 'database.dart';
import 'providers.dart' show newId;

/// URL du back-office (Next.js). Fournie au build via
/// `--dart-define=BACKOFFICE_URL=https://...` — en dev, pointe vers l'API
/// locale (`next dev`) ou le déploiement Vercel de test.
const _backofficeUrl = String.fromEnvironment(
  'BACKOFFICE_URL',
  defaultValue: 'http://localhost:3000',
);

/// Crée (ou retrouve) l'`Account` Prisma correspondant au joueur connecté,
/// puis synchronise l'historique de jeu (profils, parties, badges, cartes
/// perso — §05, phase 4) dans LES DEUX SENS avec le back-office :
/// - descente (`GET /api/sync`) D'ABORD, pour ramener sur cet appareil ce
///   qui existe déjà sur le compte (un autre appareil, ou une session
///   précédente sur celui-ci après une réinstallation) ;
/// - montée (`POST /api/sync`) ensuite, pour envoyer ce que cet appareil a
///   de nouveau. Sans le premier sens, se connecter sur un appareil qui n'a
///   jamais vu ces profils/parties ne les fait jamais réapparaître — un
///   comportement fortement surprenant, presque une perte de données aux
///   yeux du joueur.
///
/// Best-effort, jamais bloquant : hors-ligne ou back-office indisponible,
/// l'app reste utilisable normalement (§01, offline-first) — la synchro se
/// retentera à la prochaine connexion. Rejouable sans effet de bord des deux
/// côtés (upsert sur localId/clientSessionId/badgeKey/remoteId).
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

    await _pullGameData(db, headers);
    await _syncGameData(db, headers);
  } catch (_) {
    // Best-effort — voir docstring. Pas de remontée d'erreur à l'UI.
  }
}

/// Descend l'historique du compte et le fusionne dans la base locale —
/// jamais destructif : un profil/partie/badge/carte déjà présent
/// localement (même `localId`/`clientSessionId`/`badgeKey`/`remoteId`)
/// n'est ni dupliqué ni écrasé par une valeur plus ancienne, seulement
/// complété par ce qui manque.
Future<void> _pullGameData(AppDatabase db, Map<String, String> headers) async {
  final response = await http
      .get(Uri.parse('$_backofficeUrl/api/sync'), headers: headers)
      .timeout(const Duration(seconds: 20));
  if (response.statusCode != 200) return;

  final body = jsonDecode(response.body) as Map<String, dynamic>;
  final remoteProfiles = (body['profiles'] as List).cast<Map<String, dynamic>>();
  final remoteSessions = (body['sessions'] as List).cast<Map<String, dynamic>>();
  final remoteBadges = (body['badges'] as List).cast<Map<String, dynamic>>();
  final remoteCards = (body['customCards'] as List).cast<Map<String, dynamic>>();

  final existingPlayers = await db.select(db.localPlayers).get();
  final byLocalId = {for (final p in existingPlayers) p.id: p};
  final byRemoteId = {
    for (final p in existingPlayers)
      if (p.remoteId != null) p.remoteId!: p,
  };
  // Filet de sécurité quand ni l'id local ni le remoteId ne correspondent
  // déjà : un joueur du même nom joué séparément sur cet appareil ET sur le
  // compte (avant toute connexion, ou sur un autre appareil) est la même
  // personne dans le contexte de l'app (jeu de soirée, pas de comptes
  // distincts par joueur) — on fusionne sous le profil local existant
  // plutôt que de créer un doublon visible à l'écran joueurs. Normalisé
  // (casse, espaces) pour matcher la règle d'unicité déjà appliquée à la
  // création d'un profil (voir `PlayersNotifier.create`).
  final byNormalizedName = {
    for (final p in existingPlayers) p.name.trim().toLowerCase(): p,
  };
  // Un même profil local peut absorber plusieurs profils distants fusionnés
  // par nom au fil de cette passe — jamais réinséré une deuxième fois.
  final claimedLocalIds = <String>{};

  // Un profil distant peut n'exister ici ni par localId (jamais vu sur cet
  // appareil) ni par remoteId (déjà vu mais sous un autre localId, ex.
  // après une réinstallation) ni par nom (aucun homonyme local) — dans ce
  // seul cas il faut une nouvelle ligne locale avant de pouvoir y rattacher
  // des parties. `remoteToLocalPlayerId` couvre toutes les origines pour le
  // reste de la fusion (sessions).
  final remoteToLocalPlayerId = <String, String>{};
  final newPlayers = <LocalPlayersCompanion>[];
  final playerRemoteIdUpdates = <String, String>{};

  for (final rp in remoteProfiles) {
    final localId = rp['localId'] as String;
    final remoteId = rp['remoteId'] as String;
    final name = rp['name'] as String;
    final normalizedName = name.trim().toLowerCase();

    if (byLocalId.containsKey(localId)) {
      remoteToLocalPlayerId[remoteId] = localId;
      claimedLocalIds.add(localId);
      if (byLocalId[localId]!.remoteId != remoteId) playerRemoteIdUpdates[localId] = remoteId;
    } else if (byRemoteId.containsKey(remoteId)) {
      final matchId = byRemoteId[remoteId]!.id;
      remoteToLocalPlayerId[remoteId] = matchId;
      claimedLocalIds.add(matchId);
    } else if (byNormalizedName[normalizedName] case final match?
        when !claimedLocalIds.contains(match.id)) {
      remoteToLocalPlayerId[remoteId] = match.id;
      claimedLocalIds.add(match.id);
      if (match.remoteId != remoteId) playerRemoteIdUpdates[match.id] = remoteId;
    } else {
      newPlayers.add(LocalPlayersCompanion.insert(
        id: localId,
        name: name,
        avatar: (rp['avatar'] as String?) ?? '👤',
        createdAt: DateTime.now(),
        inSession: const Value(false),
        remoteId: Value(remoteId),
      ));
      remoteToLocalPlayerId[remoteId] = localId;
      claimedLocalIds.add(localId);
    }
  }

  final existingSessionIds = (await db.select(db.gameSessions).get()).map((s) => s.id).toSet();
  final newSessions = <GameSessionsCompanion>[];
  final newSessionPlayers = <SessionPlayersCompanion>[];
  // Cumuls à ajouter aux joueurs déjà locaux, tirés des parties inédites —
  // une partie neuve pour cet appareil doit se refléter sur ses stats
  // cumulées (totalScore/gamesPlayed/tagScores), pas seulement le journal.
  final scoreGains = <String, int>{};
  final gameCountGains = <String, int>{};
  final tagGains = <String, Map<String, int>>{};

  for (final rs in remoteSessions) {
    final clientSessionId = rs['clientSessionId'] as String;
    if (existingSessionIds.contains(clientSessionId)) continue;

    final players = (rs['players'] as List).cast<Map<String, dynamic>>();
    newSessions.add(GameSessionsCompanion.insert(
      id: clientSessionId,
      gameId: rs['gameId'] as String,
      categoryId: rs['categoryId'] as String,
      locale: rs['locale'] as String,
      intensity: 3, // non renvoyé par le back-office (§05) — sans effet sur l'affichage de l'historique
      cardsPlayed: players.length,
      playerCount: rs['playerCount'] as int,
      startedAt: DateTime.parse(rs['startedAt'] as String),
      finishedAt: DateTime.parse(rs['finishedAt'] as String),
      syncedAt: Value(DateTime.now()),
    ));

    for (final sp in players) {
      final profileRemoteId = sp['profileRemoteId'] as String;
      final localPlayerId = remoteToLocalPlayerId[profileRemoteId];
      if (localPlayerId == null) continue; // profil du compte supprimé entre-temps côté back-office
      final score = sp['score'] as int;
      final tags = (sp['tagScoresGained'] as Map).cast<String, dynamic>();
      newSessionPlayers.add(SessionPlayersCompanion.insert(
        sessionId: clientSessionId,
        playerId: localPlayerId,
        score: score,
        tagScoresGainedJson: jsonEncode(tags),
      ));
      scoreGains.update(localPlayerId, (v) => v + score, ifAbsent: () => score);
      gameCountGains.update(localPlayerId, (v) => v + 1, ifAbsent: () => 1);
      final cumulative = tagGains.putIfAbsent(localPlayerId, () => {});
      for (final entry in tags.entries) {
        cumulative.update(entry.key, (v) => v + (entry.value as int), ifAbsent: () => entry.value as int);
      }
    }
  }

  final existingBadgeKeys = (await db.select(db.earnedBadges).get()).map((b) => b.badgeKey).toSet();
  final newBadges = [
    for (final rb in remoteBadges)
      if (!existingBadgeKeys.contains(rb['badgeKey']))
        EarnedBadgesCompanion.insert(
          badgeKey: rb['badgeKey'] as String,
          earnedAt: DateTime.parse(rb['earnedAt'] as String),
          syncedAt: Value(DateTime.now()),
        ),
  ];

  final existingCardRemoteIds = (await db.select(db.customCards).get())
      .map((c) => c.remoteId)
      .whereType<String>()
      .toSet();
  final newCards = [
    for (final rc in remoteCards)
      if (!existingCardRemoteIds.contains(rc['remoteId']))
        CustomCardsCompanion.insert(
          id: newId(),
          gameId: rc['gameId'] as String,
          categoryId: rc['categoryId'] as String,
          text_: rc['text'] as String,
          intensity: Value(rc['intensity'] as int),
          active: Value(rc['active'] as bool),
          createdAt: DateTime.parse(rc['createdAt'] as String),
          updatedAt: DateTime.parse(rc['updatedAt'] as String),
          remoteId: Value(rc['remoteId'] as String),
          syncedAt: Value(DateTime.now()),
        ),
  ];

  if (newPlayers.isEmpty &&
      playerRemoteIdUpdates.isEmpty &&
      newSessions.isEmpty &&
      newBadges.isEmpty &&
      newCards.isEmpty) {
    return;
  }

  await db.batch((b) {
    b.insertAll(db.localPlayers, newPlayers);
    for (final entry in playerRemoteIdUpdates.entries) {
      b.update(
        db.localPlayers,
        LocalPlayersCompanion(remoteId: Value(entry.value)),
        where: (p) => p.id.equals(entry.key),
      );
    }
    b.insertAll(db.gameSessions, newSessions);
    b.insertAll(db.sessionPlayers, newSessionPlayers);
    b.insertAll(db.earnedBadges, newBadges);
    b.insertAll(db.customCards, newCards);
  });

  if (scoreGains.isNotEmpty) {
    final affected = await (db.select(db.localPlayers)..where((p) => p.id.isIn(scoreGains.keys))).get();
    await db.batch((b) {
      for (final p in affected) {
        final existingTags = (jsonDecode(p.tagScoresJson) as Map).cast<String, dynamic>();
        final merged = Map<String, int>.from(existingTags.map((k, v) => MapEntry(k, v as int)));
        for (final entry in (tagGains[p.id] ?? const {}).entries) {
          merged.update(entry.key, (v) => v + entry.value, ifAbsent: () => entry.value);
        }
        b.update(
          db.localPlayers,
          LocalPlayersCompanion(
            totalScore: Value(p.totalScore + (scoreGains[p.id] ?? 0)),
            gamesPlayed: Value(p.gamesPlayed + (gameCountGains[p.id] ?? 0)),
            tagScoresJson: Value(jsonEncode(merged)),
          ),
          where: (x) => x.id.equals(p.id),
        );
      }
    });
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
