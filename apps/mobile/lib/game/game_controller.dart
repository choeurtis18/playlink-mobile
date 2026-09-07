import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/deck.dart';
import '../core/session.dart';
import '../data/content_repository.dart';
import '../data/database.dart';
import '../data/providers.dart';

/// Écran à afficher, dérivé de l'état — jamais stocké à part (B3→B6).
enum GameStage { turn, card, vote, pass, results }

class GameState {
  const GameState({
    required this.game,
    required this.category,
    required this.deck,
    required this.index,
    required this.intensity,
    required this.locale,
    required this.startedAt,
    required this.session,
    this.revealed = false,
    this.voting = false,
    this.pendingPass = false,
    this.hintsLeft = 0,
  });

  final GameVm game;
  final CategoryVm category;
  final List<CardVm> deck;
  final int index;
  final int intensity;
  final String locale;
  final DateTime startedAt;
  final SessionState session;
  final bool revealed;
  final bool voting;
  final bool pendingPass;
  final int hintsLeft;

  GameStage get stage {
    if (session.phase == SessionPhase.results) return GameStage.results;
    if (pendingPass) return GameStage.pass;
    if (voting) return GameStage.vote;
    if (revealed) return GameStage.card;
    return GameStage.turn;
  }

  CardVm? get card => index < deck.length ? deck[index] : null;
  bool get isLastCard => index + 1 >= deck.length;
  Player get currentPlayer => session.currentPlayer!;

  GameState copyWith({
    int? index,
    SessionState? session,
    bool? revealed,
    bool? voting,
    bool? pendingPass,
    int? hintsLeft,
  }) {
    return GameState(
      game: game, category: category, deck: deck, intensity: intensity,
      locale: locale, startedAt: startedAt,
      index: index ?? this.index,
      session: session ?? this.session,
      revealed: revealed ?? this.revealed,
      voting: voting ?? this.voting,
      pendingPass: pendingPass ?? this.pendingPass,
      hintsLeft: hintsLeft ?? this.hintsLeft,
    );
  }
}

/// Orchestre une partie, comme `page.tsx` de l'app web : tirage du deck,
/// réveil de la carte, vote, passe-le-téléphone, résultats, écriture de
/// l'historique. Aucun réseau (règle absolue).
class GameController extends Notifier<GameState?> {
  @override
  GameState? build() => null;

  /// B2 → B3. Les scores et tags de départ viennent des profils durables :
  /// c'est ce qui fait cumuler les points d'une partie à l'autre.
  void start({
    required GameVm game,
    required CategoryVm category,
    required List<CardVm> categoryCards,
    required int intensity,
    required int count,
    required List<LocalPlayer> players,
    Random? random,
  }) {
    final deck = buildDeck(
      categoryCards,
      target: intensity,
      count: count,
      intensityOf: (c) => c.intensity,
      random: random,
    );
    var session = SessionState(
      players: [for (final p in players) Player(id: p.id, name: p.name, avatar: p.avatar)],
      scores: {for (final p in players) p.id: p.totalScore},
      tagScoresGained: {
        for (final p in players)
          p.id: (jsonDecode(p.tagScoresJson) as Map).cast<String, int>(),
      },
    );
    session = startSession(session);
    state = GameState(
      game: game,
      category: category,
      deck: deck,
      index: 0,
      intensity: intensity,
      locale: ref.read(localeProvider).languageCode,
      startedAt: DateTime.now(),
      session: session,
      hintsLeft: game.hintsPerCard ?? 0,
    );
  }

  /// B3 → B4. Voir la carte ne la consomme pas : le compteur n'avance pas.
  void reveal() => state = state?.copyWith(revealed: true);

  /// Devine le mot : un indice de moins, plancher à zéro.
  void useHint() {
    final s = state;
    if (s == null || s.hintsLeft == 0) return;
    state = s.copyWith(hintsLeft: s.hintsLeft - 1);
  }

  /// B4 → B5.
  void openVote() => state = state?.copyWith(voting: true);

  /// B5 : le vote est obligatoire, c'est lui qui fait avancer la partie.
  Future<void> vote({required bool point}) async {
    final s = state;
    if (s == null || s.card == null) return;
    final player = s.currentPlayer;
    final tags = s.card!.canonicalTags;
    var session = point
        ? assignPoint(s.session, player.id, tags)
        : skipCard(s.session, player.id, tags);

    if (s.isLastCard) {
      session = endSession(session);
      state = s.copyWith(session: session, voting: false, index: s.index + 1);
      await _persist();
      return;
    }

    session = nextPlayer(session);
    final multi = s.session.players.length > 1;
    state = s.copyWith(
      session: session,
      index: s.index + 1,
      voting: false,
      revealed: false,
      // Avec plusieurs joueurs, la carte suivante reste masquée jusqu'à ce
      // que le nouveau joueur confirme avoir le téléphone en main.
      pendingPass: multi,
      hintsLeft: s.game.hintsPerCard ?? 0,
    );
  }

  void confirmPass() => state = state?.copyWith(pendingPass: false);

  /// B7 « Rejouer » : retour à la config du même jeu, scores conservés.
  /// B1 « Accueil » et abandon : on lâche l'état.
  void leave() => state = null;

  /// B6 : historique + cumul durable sur les profils (game_sessions,
  /// session_players, local_players). Tout en local, synchro en phase 4.
  Future<void> _persist() async {
    final s = state!;
    final db = ref.read(databaseProvider);
    final sessionId = newId();
    final now = DateTime.now();

    // Gains de tags de CETTE partie, dérivés des cartes gagnées.
    final gained = <String, Map<String, int>>{};
    for (final r in s.session.cardResults.where((r) => r.won)) {
      final m = gained.putIfAbsent(r.playerId, () => {});
      for (final t in r.tags) {
        m[t] = (m[t] ?? 0) + 1;
      }
    }

    await db.transaction(() async {
      await db.into(db.gameSessions).insert(
            GameSessionsCompanion.insert(
              id: sessionId,
              gameId: s.game.id,
              categoryId: s.category.id,
              locale: s.locale,
              intensity: s.intensity,
              cardsPlayed: s.deck.length,
              playerCount: s.session.players.length,
              startedAt: s.startedAt,
              finishedAt: now,
            ),
          );
      for (final p in s.session.players) {
        await db.into(db.sessionPlayers).insert(
              SessionPlayersCompanion.insert(
                sessionId: sessionId,
                playerId: p.id,
                score: s.session.sessionScore(p.id),
                tagScoresGainedJson: jsonEncode(gained[p.id] ?? const {}),
              ),
            );
      }
    });

    await ref.read(playersProvider.notifier).applyGameResult(
          sessionScores: {
            for (final p in s.session.players) p.id: s.session.sessionScore(p.id),
          },
          cumulativeTagScores: s.session.tagScoresGained,
        );
  }
}

final gameControllerProvider =
    NotifierProvider<GameController, GameState?>(GameController.new);
