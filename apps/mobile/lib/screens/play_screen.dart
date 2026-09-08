import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/deck.dart';
import '../core/session.dart';
import '../core/tag_mapping.dart';
import '../game/game_controller.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import '../widgets/play_card.dart';
import '../widgets/player_avatar.dart';
import 'rules_sheet.dart';

/// B3 → B6 : un seul écran, l'étape est dérivée de l'état du contrôleur.
/// Fond sombre uni partout (réf. visuelle) : seule la carte du deck et les
/// CTA reprennent le dégradé du jeu.
class PlayScreen extends ConsumerWidget {
  const PlayScreen({super.key});

  Future<bool> _confirmQuit(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.quitGame),
        content: Text(t.quitGameBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.quit)),
        ],
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final s = ref.watch(gameControllerProvider);
    if (s == null) {
      // N'arrive normalement qu'en accès direct à /play (deep link) sans
      // partie en cours. Pas de redirection automatique ici : Rejouer et
      // goHome naviguent déjà eux-mêmes vers la bonne route avant de vider
      // l'état (ctrl.leave() en dernier), donc ce cas n'a besoin que d'un
      // filet simple — pas d'un redirect qui, exécuté un frame plus tard,
      // pourrait écraser une navigation entre-temps décidée ailleurs.
      return const Scaffold(backgroundColor: PlColors.ground, body: SizedBox.shrink());
    }
    final ctrl = ref.read(gameControllerProvider.notifier);
    final inGame = s.stage != GameStage.results;

    return PopScope(
      canPop: !inGame,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmQuit(context)) {
          if (context.mounted) context.go('/');
          ctrl.leave();
        }
      },
      child: GameScaffold(
        colorMain: s.game.colorMain,
        colorSecondary: s.game.colorSecondary,
        headerHeight: 0,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: PlColors.ink,
          leading: inGame
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    if (await _confirmQuit(context)) {
                      if (context.mounted) context.go('/');
                      ctrl.leave();
                    }
                  },
                )
              : null,
          title: inGame
              ? Text(t.cardOf(s.index.clamp(0, s.deck.length - 1) + 1, s.deck.length),
                  style: const TextStyle(fontWeight: FontWeight.w700))
              : null,
          actions: [
            IconButton(icon: const Icon(Icons.menu_book_rounded), onPressed: () => showRulesSheet(context, s.game)),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: switch (s.stage) {
            GameStage.turn => _Turn(key: const ValueKey('turn'), s: s, onReveal: () {
                HapticFeedback.mediumImpact();
                ctrl.reveal();
              }),
            GameStage.card => _Card(key: ValueKey('card-${s.index}'), s: s, ctrl: ctrl),
            GameStage.vote => _Vote(key: const ValueKey('vote'), s: s, ctrl: ctrl),
            GameStage.pass => _Pass(key: const ValueKey('pass'), s: s, onReady: () {
                HapticFeedback.lightImpact();
                ctrl.confirmPass();
              }),
            GameStage.results => _Results(key: const ValueKey('results'), s: s, ctrl: ctrl),
          },
        ),
      ),
    );
  }
}

// ─── B3 ──────────────────────────────────────────────────────────────

class _Turn extends StatelessWidget {
  const _Turn({super.key, required this.s, required this.onReveal});
  final GameState s;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = s.currentPlayer;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          const Spacer(),
          Text(t.yourTurn.toUpperCase(),
              style: const TextStyle(color: PlColors.neutral, fontSize: 12.5, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 28),
          PlayerAvatar(emoji: p.avatar, size: 96, gradient: gameGradient(s.game.colorMain, s.game.colorSecondary)),
          const SizedBox(height: 18),
          Text(p.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text(t.passPhoneHint, textAlign: TextAlign.center, style: const TextStyle(color: PlColors.neutralFaint)),
          const Spacer(),
          OnGradientButton(
            label: t.seeCard, icon: Icons.visibility_rounded, onPressed: onReveal,
            colorMain: s.game.colorMain, colorSecondary: s.game.colorSecondary,
          ),
        ],
      ),
    );
  }
}

// ─── B4 ──────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({super.key, required this.s, required this.ctrl});
  final GameState s;
  final GameController ctrl;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final card = s.card!;
    final hints = s.game.hintsPerCard;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
      child: Column(
        children: [
          Text(t.turnOf(s.currentPlayer.name), style: const TextStyle(color: PlColors.neutralFaint, fontSize: 14)),
          const SizedBox(height: 14),
          Expanded(
            child: PlayCard(
              text: card.text,
              intensityLabel: intensityLabels[card.intensity] ?? '',
              categoryLabel: s.category.name,
              gradient: gameGradient(s.game.colorMain, s.game.colorSecondary),
              behind: s.deck.length - s.index - 1,
              onSwipeToVote: ctrl.openVote,
            ),
          ),
          if (hints != null) ...[
            const SizedBox(height: 18),
            _Hints(total: hints, left: s.hintsLeft, onUse: s.hintsLeft > 0 ? () {
              HapticFeedback.selectionClick();
              ctrl.useHint();
            } : null),
          ],
          const SizedBox(height: 18),
          OnGradientButton(
            label: t.vote, icon: Icons.how_to_vote_rounded, onPressed: ctrl.openVote,
            colorMain: s.game.colorMain, colorSecondary: s.game.colorSecondary,
          ),
        ],
      ),
    );
  }
}

/// Devine le mot : trois indices, pas un de plus (slides de règles).
class _Hints extends StatelessWidget {
  const _Hints({required this.total, required this.left, required this.onUse});
  final int total;
  final int left;
  final VoidCallback? onUse;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            width: 14, height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < left ? PlColors.ink : PlColors.hairlineFirm,
            ),
          ),
        const SizedBox(width: 6),
        Expanded(child: Text(t.hintsLeft(left), style: const TextStyle(color: PlColors.inkSoft, fontWeight: FontWeight.w600))),
        GhostButton(label: t.useHint, onPressed: onUse),
      ],
    );
  }
}

// ─── B5 ──────────────────────────────────────────────────────────────

class _Vote extends StatelessWidget {
  const _Vote({super.key, required this.s, required this.ctrl});
  final GameState s;
  final GameController ctrl;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rappel compact de la carte (réf. visuelle : la carte réduite
          // reste visible en haut de l'écran de vote).
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: gameGradient(s.game.colorMain, s.game.colorSecondary),
              borderRadius: BorderRadius.circular(PlRadius.card),
            ),
            child: Text(
              s.card?.text ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, height: 1.3),
            ),
          ),
          const Spacer(flex: 2),
          Text(t.vote.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: PlColors.neutral, fontSize: 12.5, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            t.deservesPoint(s.currentPlayer.name),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.25, letterSpacing: -0.3),
          ),
          const Spacer(flex: 3),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 92,
                  child: OutlinedButton(
                    onPressed: () { HapticFeedback.lightImpact(); ctrl.vote(point: false); },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PlColors.ink,
                      backgroundColor: PlColors.surface,
                      side: const BorderSide(color: PlColors.hairlineFirm),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.card)),
                      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('👎', style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(t.no),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 92,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: gameGradient(s.game.colorMain, s.game.colorSecondary),
                      borderRadius: BorderRadius.circular(PlRadius.card),
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(PlRadius.card),
                        onTap: () { HapticFeedback.heavyImpact(); ctrl.vote(point: true); },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('👍', style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(t.yes, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(t.voteIsMandatory,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PlColors.neutralFaint, fontSize: 11.5)),
        ],
      ),
    );
  }
}

// ─── B5 · passe le téléphone ─────────────────────────────────────────

class _Pass extends StatelessWidget {
  const _Pass({super.key, required this.s, required this.onReady});
  final GameState s;
  final VoidCallback onReady;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = s.currentPlayer;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          const Spacer(),
          const Text('📱', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          Text(
            t.passPhoneTo(p.name),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -0.3),
          ),
          const SizedBox(height: 16),
          PlayerAvatar(emoji: p.avatar, size: 64, gradient: gameGradient(s.game.colorMain, s.game.colorSecondary)),
          const SizedBox(height: 16),
          Text(t.passPhoneHint, textAlign: TextAlign.center, style: const TextStyle(color: PlColors.neutralFaint)),
          const Spacer(),
          OnGradientButton(
            label: t.imReady, icon: Icons.check_rounded, onPressed: onReady,
            colorMain: s.game.colorMain, colorSecondary: s.game.colorSecondary,
          ),
        ],
      ),
    );
  }
}

// ─── B6 ──────────────────────────────────────────────────────────────

class _Results extends StatelessWidget {
  const _Results({super.key, required this.s, required this.ctrl});
  final GameState s;
  final GameController ctrl;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final ranked = List<Player>.of(s.session.players)
      ..sort((a, b) => s.session.sessionScore(b.id).compareTo(s.session.sessionScore(a.id)));
    const medals = ['🥇', '🥈', '🥉'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
      child: Column(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 14),
          Text(t.gameOver, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
          const SizedBox(height: 4),
          Text('${s.category.name} · ${t.cardsCount(s.deck.length)} · ${t.intensity.toLowerCase()} ${s.intensity}',
              style: const TextStyle(color: PlColors.neutralFaint, fontSize: 13)),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < ranked.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    Builder(builder: (_) {
                      final p = ranked[i];
                      final archetype = getPlayerType(s.session.tagScoresGained[p.id] ?? const {});
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: PlColors.surface,
                          borderRadius: BorderRadius.circular(PlRadius.tile),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(i < 3 ? medals[i] : '${i + 1}',
                                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 10),
                            PlayerAvatar(emoji: p.avatar, size: 40, gradient: gameGradient(s.game.colorMain, s.game.colorSecondary)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                  Text(archetype, style: TextStyle(color: hexColor(s.game.colorMain), fontSize: 12.5)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(t.sessionScore(s.session.sessionScore(p.id)),
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                                Text(t.totalScore(s.session.scores[p.id] ?? 0),
                                    style: const TextStyle(color: PlColors.neutralFaint, fontSize: 11.5)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OnGradientButton(
            label: t.replay,
            icon: Icons.replay_rounded,
            colorMain: s.game.colorMain,
            colorSecondary: s.game.colorSecondary,
            onPressed: () {
              // Naviguer AVANT de vider l'état : sinon PlayScreen se
              // reconstruit un instant avec s == null pendant la transition
              // de route et programme un redirect vers la home qui
              // s'exécute même après l'arrivée sur ConfigScreen.
              final slug = s.game.slug, cat = s.category.id;
              context.go('/game/$slug/config/$cat');
              ctrl.leave();
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Le partage (E2) est une fonctionnalité de phase 5 — le bouton
              // existe visuellement (réf.) mais reste désactivé tant qu'elle
              // n'est pas construite, plutôt que de simuler une action.
              Expanded(child: GhostButton(label: t.shareScore, onPressed: null)),
              const SizedBox(width: 10),
              Expanded(child: GhostButton(label: t.goHome, onPressed: () { context.go('/'); ctrl.leave(); })),
            ],
          ),
        ],
      ),
    );
  }
}
