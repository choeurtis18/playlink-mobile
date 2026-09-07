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
      return const Scaffold(body: SizedBox.shrink());
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
        appBar: AppBar(
          foregroundColor: Colors.white,
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
          PlayerAvatar(emoji: p.avatar, size: 96, onDark: true),
          const SizedBox(height: 18),
          Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text(t.yourTurn, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 17)),
          const Spacer(),
          OnGradientButton(label: t.seeCard, icon: Icons.visibility_rounded, onPressed: onReveal),
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
          Text(t.turnOf(s.currentPlayer.name), style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15)),
          const SizedBox(height: 14),
          Expanded(
            child: PlayCard(
              text: card.text,
              intensityLabel: intensityLabels[card.intensity] ?? '',
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
          OnGradientButton(label: t.vote, icon: Icons.how_to_vote_rounded, onPressed: ctrl.openVote),
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
              color: i < left ? Colors.white : Colors.white.withValues(alpha: 0.25),
            ),
          ),
        const SizedBox(width: 6),
        Expanded(child: Text(t.hintsLeft(left), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600))),
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
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          const Spacer(),
          PlayerAvatar(emoji: s.currentPlayer.avatar, size: 72, onDark: true),
          const SizedBox(height: 20),
          Text(t.deservesPoint(s.currentPlayer.name),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.2, letterSpacing: -0.4)),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 92,
                  child: OutlinedButton(
                    onPressed: () { HapticFeedback.lightImpact(); ctrl.vote(point: false); },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.14),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.card)),
                      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    child: Text('👎  ${t.no}'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 92,
                  child: FilledButton(
                    onPressed: () { HapticFeedback.heavyImpact(); ctrl.vote(point: true); },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF15131F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.card)),
                      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    child: Text('👍  ${t.yes}'),
                  ),
                ),
              ),
            ],
          ),
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
    return Container(
      color: const Color(0xCC0D0C16),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          const Spacer(),
          const Text('📱', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          Text(t.passPhoneTo(p.name),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.4)),
          const SizedBox(height: 14),
          PlayerAvatar(emoji: p.avatar, size: 64, onDark: true),
          const SizedBox(height: 14),
          Text(t.passPhoneHint, textAlign: TextAlign.center, style: const TextStyle(color: PlColors.neutral)),
          const Spacer(),
          OnGradientButton(label: t.imReady, icon: Icons.check_rounded, onPressed: onReady),
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
          Text(t.gameOver, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text('${s.game.icon} ${s.game.name} · ${s.category.name}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: ranked.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final p = ranked[i];
                final archetype = getPlayerType(s.session.tagScoresGained[p.id] ?? const {});
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: i == 0 ? 0.95 : 0.16),
                    borderRadius: BorderRadius.circular(PlRadius.tile),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Text(i < 3 ? medals[i] : '${i + 1}', style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      PlayerAvatar(emoji: p.avatar, size: 40, onDark: i != 0),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: TextStyle(color: i == 0 ? const Color(0xFF15131F) : Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                            Text(archetype, style: TextStyle(color: i == 0 ? PlColors.neutral : Colors.white70, fontSize: 12.5)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(t.sessionScore(s.session.sessionScore(p.id)),
                              style: TextStyle(color: i == 0 ? const Color(0xFF15131F) : Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                          Text(t.totalScore(s.session.scores[p.id] ?? 0),
                              style: TextStyle(color: i == 0 ? PlColors.neutral : Colors.white70, fontSize: 11.5)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          OnGradientButton(
            label: t.replay,
            icon: Icons.replay_rounded,
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
          GhostButton(label: t.goHome, onPressed: () { context.go('/'); ctrl.leave(); }),
        ],
      ),
    );
  }
}
