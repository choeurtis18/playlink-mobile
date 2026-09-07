import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/core/session.dart';
import 'package:playlink/core/tag_mapping.dart';

const lina = Player(id: 'p1', name: 'Lina', avatar: '🦊');
const sam = Player(id: 'p2', name: 'Sam', avatar: '⚡');

void main() {
  final base = startSession(const SessionState(players: [lina, sam]));

  test('startSession : phase playing, joueur 0, scores initialisés, instantané figé', () {
    expect(base.phase, SessionPhase.playing);
    expect(base.currentPlayerIndex, 0);
    expect(base.scores, {'p1': 0, 'p2': 0});
    expect(base.scoresBeforeSession, {'p1': 0, 'p2': 0});
    expect(base.currentPlayer, lina);
  });

  test('assignPoint : +1, tags cumulés, phase voting', () {
    final s = assignPoint(base, 'p1', ['humour', 'vérité']);
    expect(s.scores['p1'], 1);
    expect(s.tagScoresGained['p1'], {'humour': 1, 'vérité': 1});
    expect(s.phase, SessionPhase.voting);
    expect(s.cardResults.single.won, isTrue);
  });

  test('skipCard : aucun point, aucun tag, résultat enregistré', () {
    final s = skipCard(base, 'p1', ['humour']);
    expect(s.scores['p1'], 0);
    expect(s.tagScoresGained['p1'], isEmpty);
    expect(s.cardResults.single.won, isFalse);
    expect(s.phase, SessionPhase.voting);
  });

  test('nextPlayer boucle sur la liste', () {
    var s = nextPlayer(base);
    expect(s.currentPlayer, sam);
    expect(s.phase, SessionPhase.playing);
    s = nextPlayer(s);
    expect(s.currentPlayer, lina);
  });

  test('les scores cumulent entre les parties, sessionScore isole la partie', () {
    var s = assignPoint(base, 'p1', ['humour']);
    s = assignPoint(s, 'p1', ['humour']);
    s = endSession(s);
    expect(s.sessionScore('p1'), 2);

    // Nouvelle partie : cumul conservé, instantané mis à jour.
    s = startSession(resetSession(s));
    expect(s.scores['p1'], 2);
    expect(s.sessionScore('p1'), 0);
    s = assignPoint(s, 'p1', ['flirt']);
    expect(s.scores['p1'], 3);
    expect(s.sessionScore('p1'), 1);
    expect(s.tagScoresGained['p1'], {'humour': 2, 'flirt': 1});
  });

  test('resetSession garde joueurs/scores/tags, efface le reste', () {
    var s = assignPoint(base, 'p2', ['tabou']);
    s = resetSession(s);
    expect(s.phase, SessionPhase.idle);
    expect(s.players, [lina, sam]);
    expect(s.scores['p2'], 1);
    expect(s.tagScoresGained['p2'], {'tabou': 1});
    expect(s.cardResults, isEmpty);
    expect(s.scoresBeforeSession, isEmpty);
  });

  test('clearScores remet les cumuls à zéro', () {
    final s = clearScores(assignPoint(base, 'p1', ['humour']));
    expect(s.scores, isEmpty);
    expect(s.tagScoresGained, isEmpty);
    expect(s.players, [lina, sam]);
  });

  test('archétype dérivé des tags cumulés', () {
    var s = assignPoint(base, 'p1', ['humour', 'vérité']);
    s = assignPoint(s, 'p1', ['humour', 'vérité']);
    s = assignPoint(s, 'p1', ['humour', 'ambition']);
    expect(getPlayerType(s.tagScoresGained['p1']!), 'Le Clown de service');
  });
}
