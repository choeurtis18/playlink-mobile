// Portage de `sessionStore` (Zustand) de l'app web, sous forme de réducteur
// pur : un état immuable et des fonctions qui en dérivent le suivant. Le
// provider Riverpod l'enveloppe ; la persistance vient de drift (phase 3).
//
// Règle héritée à conserver : les scores et tags CUMULENT entre les parties.
// `resetSession` garde players, scores et tagScoresGained ; seul un reset
// explicite de l'utilisateur les efface.

enum SessionPhase { idle, setup, playing, voting, results }

class Player {
  const Player({required this.id, required this.name, required this.avatar});
  final String id;
  final String name;
  final String avatar;
}

class CardResult {
  const CardResult({
    required this.cardId,
    required this.tags,
    required this.playerId,
    required this.won,
  });
  final String cardId;
  final List<String> tags;
  final String playerId;
  final bool won;
}

class SessionState {
  const SessionState({
    this.phase = SessionPhase.idle,
    this.players = const [],
    this.currentPlayerIndex = 0,
    this.scores = const {},
    this.scoresBeforeSession = const {},
    this.tagScoresGained = const {},
    this.cardResults = const [],
  });

  final SessionPhase phase;
  final List<Player> players;
  final int currentPlayerIndex;
  final Map<String, int> scores;
  final Map<String, int> scoresBeforeSession;
  final Map<String, Map<String, int>> tagScoresGained;
  final List<CardResult> cardResults;

  Player? get currentPlayer =>
      players.isEmpty ? null : players[currentPlayerIndex % players.length];

  /// Score de la partie en cours = cumul − cumul au début de la partie.
  /// C'est ce que `GameResults` affiche et classe (§02).
  int sessionScore(String playerId) =>
      (scores[playerId] ?? 0) - (scoresBeforeSession[playerId] ?? 0);

  SessionState copyWith({
    SessionPhase? phase,
    List<Player>? players,
    int? currentPlayerIndex,
    Map<String, int>? scores,
    Map<String, int>? scoresBeforeSession,
    Map<String, Map<String, int>>? tagScoresGained,
    List<CardResult>? cardResults,
  }) {
    return SessionState(
      phase: phase ?? this.phase,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      scores: scores ?? this.scores,
      scoresBeforeSession: scoresBeforeSession ?? this.scoresBeforeSession,
      tagScoresGained: tagScoresGained ?? this.tagScoresGained,
      cardResults: cardResults ?? this.cardResults,
    );
  }
}

Map<String, int> _mergeTags(Map<String, int> current, List<String> tags) {
  final next = Map<String, int>.of(current);
  for (final tag in tags) {
    next[tag] = (next[tag] ?? 0) + 1;
  }
  return next;
}

/// Début de partie : fige un instantané des scores pour calculer ensuite le
/// score de la partie, garantit une entrée par joueur, repart du joueur 0.
SessionState startSession(SessionState s) {
  final scores = <String, int>{};
  final tags = <String, Map<String, int>>{};
  for (final p in s.players) {
    scores[p.id] = s.scores[p.id] ?? 0;
    tags[p.id] = s.tagScoresGained[p.id] ?? const {};
  }
  return s.copyWith(
    phase: SessionPhase.playing,
    currentPlayerIndex: 0,
    scores: scores,
    scoresBeforeSession: Map<String, int>.of(scores),
    tagScoresGained: tags,
    cardResults: const [],
  );
}

/// Le groupe a voté « Point » : +1 et les tags CANONIQUES de la carte
/// s'ajoutent au profil — c'est sur eux que `getPlayerType` calcule
/// l'archétype (§07 : pré-calculés pour ça).
SessionState assignPoint(SessionState s, String playerId, List<String> canonicalTags) {
  final scores = Map<String, int>.of(s.scores);
  scores[playerId] = (scores[playerId] ?? 0) + 1;
  final tags = Map<String, Map<String, int>>.of(s.tagScoresGained);
  tags[playerId] = _mergeTags(tags[playerId] ?? const {}, canonicalTags);
  return s.copyWith(
    phase: SessionPhase.voting,
    scores: scores,
    tagScoresGained: tags,
    cardResults: [
      ...s.cardResults,
      CardResult(
        cardId: 'card-${s.cardResults.length}',
        tags: canonicalTags,
        playerId: playerId,
        won: true,
      ),
    ],
  );
}

/// « Raté » : on enregistre le résultat sans point ni tag.
SessionState skipCard(SessionState s, String playerId, List<String> canonicalTags) {
  return s.copyWith(
    phase: SessionPhase.voting,
    cardResults: [
      ...s.cardResults,
      CardResult(
        cardId: 'card-${s.cardResults.length}',
        tags: canonicalTags,
        playerId: playerId,
        won: false,
      ),
    ],
  );
}

SessionState nextPlayer(SessionState s) {
  if (s.players.isEmpty) return s;
  return s.copyWith(
    phase: SessionPhase.playing,
    currentPlayerIndex: (s.currentPlayerIndex + 1) % s.players.length,
  );
}

SessionState endSession(SessionState s) => s.copyWith(phase: SessionPhase.results);

/// Conserve joueurs, scores cumulés et tags ; efface le reste.
SessionState resetSession(SessionState s) {
  return SessionState(
    players: s.players,
    scores: s.scores,
    tagScoresGained: s.tagScoresGained,
  );
}

/// Reset explicite demandé par l'utilisateur : remet les cumuls à zéro.
SessionState clearScores(SessionState s) {
  return SessionState(players: s.players);
}
