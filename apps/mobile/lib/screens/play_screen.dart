import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/deck.dart';
import '../core/session.dart';
import '../core/tag_mapping.dart';
import '../data/badges_repository.dart';
import '../data/providers.dart';
import '../game/game_controller.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import '../widgets/play_card.dart';
import '../widgets/player_avatar.dart';
import 'edit_player_sheet.dart';
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
        headerHeight: 0,
        // Écran "passe le téléphone" : fond plein dégradé (`_Pass`) au lieu
        // du fond sombre uni des autres étapes — sans ceci, la bande
        // status bar/AppBar (couverte nulle part par `body`) laisserait
        // transparaître le fond du thème au lieu du dégradé du jeu.
        backgroundColor: s.stage == GameStage.pass ? hexColor(s.game.colorMain) : null,
        // Sur l'écran résultats (!inGame), aucune AppBar : elle réserverait
        // son espace standard même vide, en plus du padding de `_Results` —
        // ce dernier gère seul son espacement au-dessus du titre.
        appBar: inGame
            ? AppBar(
                backgroundColor: Colors.transparent,
                // Sur l'écran plein dégradé (passe-le-téléphone), le texte
                // doit rester blanc quel que soit le thème (le fond derrière
                // l'AppBar est alors la couleur du jeu, jamais claire) ;
                // ailleurs (tour/carte/vote), suivre le thème — sinon ce
                // texte reste blanc fixe et devient illisible sur fond clair.
                foregroundColor: s.stage == GameStage.pass ? Colors.white : Theme.of(context).colorScheme.onSurface,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    if (await _confirmQuit(context)) {
                      if (context.mounted) context.go('/');
                      ctrl.leave();
                    }
                  },
                ),
                title: Text(t.cardOf(s.index.clamp(0, s.deck.length - 1) + 1, s.deck.length),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                actions: [
                  IconButton(icon: const Icon(Icons.menu_book_rounded), onPressed: () => showRulesSheet(context, s.game)),
                ],
              )
            : null,
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
            GameStage.results => _Results(key: const ValueKey('results'), s: s, ctrl: ctrl, ref: ref),
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
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          const Spacer(),
          Text(t.yourTurn.toUpperCase(),
              style: TextStyle(color: soft, fontSize: 12.5, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 28),
          _PulsingAvatar(emoji: p.avatar, gradient: gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true)),
          const SizedBox(height: 18),
          Text(p.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text(t.passPhoneHint, textAlign: TextAlign.center, style: TextStyle(color: soft)),
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

/// Avatar qui grossit/rétrécit doucement en boucle (respiration) — attire
/// l'œil sur l'écran « C'est à ton tour ! » sans être une vraie animation
/// d'attente (pas de spinner).
class _PulsingAvatar extends StatefulWidget {
  const _PulsingAvatar({required this.emoji, required this.gradient});
  final String emoji;
  final Gradient gradient;

  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);
  late final _scale = Tween<double>(begin: 0.94, end: 1.06).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: PlayerAvatar(emoji: widget.emoji, size: 96, gradient: widget.gradient),
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
          _TurnOfLabel(name: s.currentPlayer.name, nameColor: hexColor(s.game.colorMain)),
          const SizedBox(height: 14),
          Expanded(
            child: PlayCard(
              text: card.text,
              intensityLabel: intensityLabels[card.intensity] ?? '',
              categoryLabel: s.category.name,
              gradient: gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true),
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

/// « C'est au tour de {name} » avec le nom coloré (couleur du jeu) — le nom
/// n'est pas forcément en fin de phrase selon la langue (`turnOf`), donc on
/// découpe la string déjà interpolée sur son occurrence plutôt que de
/// supposer sa position dans le gabarit.
class _TurnOfLabel extends StatelessWidget {
  const _TurnOfLabel({required this.name, required this.nameColor});
  final String name;
  final Color nameColor;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final full = t.turnOf(name);
    final i = full.indexOf(name);
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    final style = TextStyle(color: soft, fontSize: 14);
    if (i < 0) return Text(full, style: style);
    return Text.rich(
      TextSpan(style: style, children: [
        TextSpan(text: full.substring(0, i)),
        TextSpan(text: name, style: TextStyle(color: nameColor, fontWeight: FontWeight.w700)),
        TextSpan(text: full.substring(i + name.length)),
      ]),
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
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            width: 14, height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < left ? scheme.onSurface : Theme.of(context).dividerColor,
            ),
          ),
        const SizedBox(width: 6),
        Expanded(child: Text(t.hintsLeft(left), style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600))),
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
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
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
              gradient: gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true),
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
              style: TextStyle(color: soft, fontSize: 12.5, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
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
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      side: BorderSide(color: Theme.of(context).dividerColor),
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
                      gradient: gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true),
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
              style: TextStyle(color: soft, fontSize: 11.5)),
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
    // Fond plein dégradé du jeu (réf. visuelle) — remplit tout l'espace sous
    // l'AppBar transparente. La bande status bar/AppBar elle-même (que ce
    // `body` ne couvre pas, réservée par le `SafeArea` de `GameScaffold`)
    // est couverte séparément par `GameScaffold.backgroundColor`, fixé par
    // `PlayScreen` à la couleur du jeu sur cette seule étape.
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true)),
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            children: [
              const Spacer(flex: 3),
              _ShakingPhone(color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(height: 28),
              Text(t.passPhoneTo(p.name).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12.5, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(
                p.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.4),
              ),
              const SizedBox(height: 16),
              Text(t.dontPeekHint,
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.4)),
              const Spacer(flex: 4),
              _WhitePillButton(label: t.itsMe(p.name), textColor: hexColor(s.game.colorMain), onTap: onReady),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icône téléphone qui vibre légèrement en boucle (réf. visuelle : « comme
/// s'il sonnait ») — petite rotation + translation, pas un vrai bruit ni
/// une notification réelle.
class _ShakingPhone extends StatefulWidget {
  const _ShakingPhone({required this.color});
  final Color color;

  @override
  State<_ShakingPhone> createState() => _ShakingPhoneState();
}

class _ShakingPhoneState extends State<_ShakingPhone> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        // Une courte salve de secousses puis une pause, en boucle.
        const shakeWindow = 0.32;
        final t = _ctrl.value;
        double offset = 0;
        double angle = 0;
        if (t < shakeWindow) {
          final wobble = sin(t / shakeWindow * pi * 7);
          offset = wobble * 4;
          angle = wobble * 0.09;
        }
        return Transform.translate(
          offset: Offset(offset, 0),
          child: Transform.rotate(angle: angle, child: child),
        );
      },
      child: Icon(Icons.smartphone_rounded, size: 56, color: widget.color),
    );
  }
}

/// CTA blanc plein, texte coloré — écran « passe le téléphone » (réf.
/// visuelle) : contraste inverse des `OnGradientButton` habituels, pour
/// ressortir sur le fond plein dégradé de cet écran précis.
class _WhitePillButton extends StatelessWidget {
  const _WhitePillButton({required this.label, required this.textColor, required this.onTap});
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(PlRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: textColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── B6 ──────────────────────────────────────────────────────────────

class _Results extends StatefulWidget {
  const _Results({super.key, required this.s, required this.ctrl, required this.ref});
  final GameState s;
  final GameController ctrl;
  final WidgetRef ref;

  @override
  State<_Results> createState() => _ResultsState();
}

class _ResultsState extends State<_Results> {
  // Clés déjà présentées : `newlyEarnedBadges` peut arriver en deux temps
  // sur CE MÊME widget monté — `vote()` bascule d'abord `state` sur le
  // stage résultats (badges pas encore calculés, liste vide), puis un
  // second `state =` la remplit une fois `checkAndAward()` résolu. Un
  // widget `key`-stable ne remonte pas entre les deux : `didUpdateWidget`,
  // pas `didChangeDependencies` (qui ne réagit qu'à un changement
  // d'InheritedWidget, pas à un changement de props), est le hook fiable
  // pour attraper ce second passage — `didChangeDependencies` seul ratait
  // silencieusement le second badge d'une partie qui en débloque un après
  // l'autre.
  final Set<String> _celebratedKeys = {};

  @override
  void initState() {
    super.initState();
    _maybeCelebrate();
  }

  @override
  void didUpdateWidget(_Results oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeCelebrate();
  }

  void _maybeCelebrate() {
    final toShow = widget.s.newlyEarnedBadges.where((k) => !_celebratedKeys.contains(k)).toList();
    if (toShow.isEmpty) return;
    _celebratedKeys.addAll(toShow);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showBadgeCelebration(context, toShow));
  }

  Future<void> _showBadgeCelebration(BuildContext context, List<String> keys) async {
    final repo = widget.ref.read(badgesRepositoryProvider);
    final locale = widget.ref.read(localeProvider).languageCode;
    final all = await repo.all(locale);
    for (final key in keys) {
      final badge = all.where((b) => b.key == key).firstOrNull;
      if (badge == null || !context.mounted) continue;
      await showBadgeUnlockedDialog(context, badge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final ctrl = widget.ctrl;
    final ref = widget.ref;
    final t = AppLocalizations.of(context);
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    final ranked = List<Player>.of(s.session.players)
      ..sort((a, b) => s.session.sessionScore(b.id).compareTo(s.session.sessionScore(a.id)));
    final podium = ranked.take(3).toList();
    final rest = ranked.length > 3 ? ranked.sublist(3) : const <Player>[];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        children: [
          Text(t.gameOver.replaceAll(' 🎉', '').toUpperCase(),
              style: TextStyle(color: soft, fontSize: 12, letterSpacing: 1.6, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(t.winnerAnnounce(ranked.first.name),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
          const SizedBox(height: 4),
          Text('${s.category.name} · ${t.cardsCount(s.deck.length)} · ${t.intensity.toLowerCase()} ${s.intensity}',
              style: TextStyle(color: soft, fontSize: 13)),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Podium(podium: podium, s: s, ref: ref),
                  if (rest.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    for (var i = 0; i < rest.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      _ResultRow(rank: i + 4, player: rest[i], s: s, ref: ref),
                    ],
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
              // s'exécute même après l'arrivée sur GameScreen.
              // Vers la page catégorie, pas directement la config : Rejouer
              // laisse choisir une autre catégorie plutôt que de relancer
              // celle d'avant telle quelle.
              final slug = s.game.slug;
              context.go('/game/$slug');
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

/// Podium du top 3 (réf. visuelle) : ordre visuel 2e-1er-3e, le 1er
/// surélevé et sur une carte au dégradé du jeu, 2e/3e sur fond sombre.
/// S'affiche même avec 1 ou 2 joueurs seulement (colonnes manquantes omises).
/// Ouvre la feuille d'édition du profil correspondant à ce joueur de
/// session — introuvable seulement si le profil a été supprimé entre la fin
/// de partie et ce tap (fenêtre très étroite), auquel cas on ignore le tap
/// plutôt que de planter.
void _openEditFor(BuildContext context, WidgetRef ref, Player player) {
  final local = ref.read(playersProvider).where((p) => p.id == player.id).firstOrNull;
  if (local != null) showEditPlayerSheet(context, ref, local);
}

/// Modale de félicitations (B6, blueprint) : « Félicitations ! Tu as
/// débloqué le badge {x} », dismissible, affichée AVANT le reste de l'écran
/// des résultats — une par badge nouvellement débloqué.
Future<void> showBadgeUnlockedDialog(BuildContext context, BadgeVm badge) {
  final t = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final soft = Theme.of(dialogContext).textTheme.bodyMedium?.color ?? Theme.of(dialogContext).colorScheme.onSurface;
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.card)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(gradient: accentGradient, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(badge.icon, style: const TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 20),
              Text(t.badgeUnlockedTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('${t.badgeUnlockedBody} « ${badge.name} »',
                  textAlign: TextAlign.center, style: TextStyle(color: soft, height: 1.4)),
              const SizedBox(height: 4),
              Text(badge.description, textAlign: TextAlign.center, style: TextStyle(color: soft, fontSize: 12.5)),
              const SizedBox(height: 22),
              AccentButton(label: t.ok, onPressed: () => Navigator.pop(dialogContext)),
            ],
          ),
        ),
      );
    },
  );
}

class _Podium extends StatelessWidget {
  const _Podium({required this.podium, required this.s, required this.ref});
  final List<Player> podium;
  final GameState s;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final first = podium.isNotEmpty ? podium[0] : null;
    final second = podium.length > 1 ? podium[1] : null;
    final third = podium.length > 2 ? podium[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null) Expanded(child: _PodiumColumn(rank: 2, player: second, s: s, height: 132, ref: ref)),
        if (second != null) const SizedBox(width: 10),
        if (first != null) Expanded(child: _PodiumColumn(rank: 1, player: first, s: s, height: 172, ref: ref)),
        if (third != null) const SizedBox(width: 10),
        if (third != null) Expanded(child: _PodiumColumn(rank: 3, player: third, s: s, height: 112, ref: ref)),
      ],
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({required this.rank, required this.player, required this.s, required this.height, required this.ref});
  final int rank;
  final Player player;
  final GameState s;
  final double height;
  final WidgetRef ref;

  static const _medals = {1: '🥇', 2: '🥈', 3: '🥉'};

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isFirst = rank == 1;
    final gradient = gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true);

    return InkWell(
      borderRadius: BorderRadius.circular(PlRadius.tile),
      onTap: () => _openEditFor(context, ref, player),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayerAvatar(
            emoji: player.avatar,
            size: isFirst ? 56 : 44,
            gradient: isFirst ? gradient : null,
          ),
          const SizedBox(height: 8),
          Text(player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: isFirst ? 17 : 15)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: height,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 14),
            decoration: BoxDecoration(
              gradient: isFirst ? gradient : null,
              color: isFirst ? null : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(PlRadius.tile),
              boxShadow: isFirst
                  ? [BoxShadow(color: hexColor(s.game.colorMain).withValues(alpha: 0.45), blurRadius: 24, offset: const Offset(0, 8))]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_medals[rank]!, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(t.sessionScore(s.session.sessionScore(player.id)),
                    style: TextStyle(
                      color: isFirst ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ligne de classement pour le 4e joueur et au-delà — sous le podium.
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.rank, required this.player, required this.s, required this.ref});
  final int rank;
  final Player player;
  final GameState s;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final archetype = getPlayerType(s.session.tagScoresGained[player.id] ?? const {});
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(PlRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        onTap: () => _openEditFor(context, ref, player),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text('$rank', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: soft)),
              ),
              const SizedBox(width: 10),
              PlayerAvatar(emoji: player.avatar, size: 40, gradient: gameGradient(s.game.colorMain, s.game.colorSecondary, vertical: true)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(player.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    Text(archetype, style: TextStyle(color: hexColor(s.game.colorMain), fontSize: 12.5)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(t.sessionScore(s.session.sessionScore(player.id)),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  Text(t.totalScore(s.session.scores[player.id] ?? 0),
                      style: TextStyle(color: soft, fontSize: 11.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
