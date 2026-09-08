import 'dart:math';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/deck.dart';
import '../data/content_repository.dart';
import '../data/providers.dart';
import '../game/game_controller.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import 'game_screen.dart';

final _cardsProvider = FutureProvider.family<List<CardVm>, String>((ref, categoryId) {
  final locale = ref.watch(localeProvider).languageCode;
  return ref.watch(contentRepositoryProvider).cards(categoryId, locale);
});

/// B2 : aperçu d'une carte, intensité 1–5 (mémorisée par jeu), cartes par
/// partie. Les joueurs ne sont pas redemandés : la liste de session joue.
/// Fond sombre sous un bandeau compact (réf. visuelle) — la carte d'aperçu
/// et le CTA reprennent le dégradé du jeu, le reste est sur fond sombre uni.
class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key, required this.slug, required this.categoryId});
  final String slug;
  final String categoryId;

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  int? _previewIndex;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final game = ref.watch(gameBySlugProvider(widget.slug)).value;
    if (game == null) {
      return const Scaffold(backgroundColor: PlColors.ground, body: Center(child: CircularProgressIndicator()));
    }
    final category = ref.watch(categoriesProvider(game.id)).value
        ?.firstWhere((c) => c.id == widget.categoryId);
    final cards = ref.watch(_cardsProvider(widget.categoryId)).value ?? const <CardVm>[];
    final prefs = ref.watch(prefsProvider);
    final intensity = prefs.intensityFor(game.id);
    final count = prefs.cardsPerGame;
    final players = ref.watch(playersProvider).where((p) => p.inSession).toList();

    // Aperçu stable : tiré une fois, pas à chaque rebuild (useMemo web).
    if (cards.isNotEmpty && _previewIndex == null) {
      _previewIndex = Random().nextInt(cards.length);
    }
    final preview = _previewIndex == null || cards.isEmpty ? null : cards[_previewIndex!];
    final gradient = gameGradient(game.colorMain, game.colorSecondary);

    return GameScaffold(
      colorMain: game.colorMain,
      colorSecondary: game.colorSecondary,
      headerHeight: 100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(game.name.toUpperCase(),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w600)),
            Text(category?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label(t.preview),
                  const SizedBox(height: 8),
                  _PreviewCard(gradient: gradient, text: preview?.text, intensity: preview?.intensity),
                  const SizedBox(height: 26),
                  _Label(game.intensityIsDifficulty ? t.difficulty : t.intensity),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = intensityMin; i <= intensityMax; i++) ...[
                        Expanded(
                          child: _Segment(
                            label: '$i',
                            selected: i == intensity,
                            gradient: gradient,
                            onTap: () => ref.read(prefsProvider.notifier).set(PrefKeys.intensity(game.id), '$i'),
                          ),
                        ),
                        if (i < intensityMax) const SizedBox(width: 6),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(intensityLabels[intensity]!,
                      style: const TextStyle(color: PlColors.neutral, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 26),
                  _Label(t.cardsPerGame),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _RoundButton(icon: Icons.remove, onTap: count > 5
                          ? () => ref.read(prefsProvider.notifier).set(PrefKeys.cardsPerGame, '${count - 1}') : null),
                      Expanded(
                        child: Text('$count', textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                      ),
                      _RoundButton(icon: Icons.add, onTap: count < 20
                          ? () => ref.read(prefsProvider.notifier).set(PrefKeys.cardsPerGame, '${count + 1}') : null),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: PlColors.surface,
                      borderRadius: BorderRadius.circular(PlRadius.tile),
                    ),
                    child: Row(
                      children: [
                        Text(players.map((p) => p.avatar).join(' '), style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(players.map((p) => p.name).join(', '),
                              style: const TextStyle(color: PlColors.inkSoft, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: OnGradientButton(
              label: t.startGame,
              icon: Icons.play_arrow_rounded,
              colorMain: game.colorMain,
              colorSecondary: game.colorSecondary,
              onPressed: cards.isEmpty || category == null || players.isEmpty
                  ? null
                  : () {
                      ref.read(gameControllerProvider.notifier).start(
                            game: game,
                            category: category,
                            categoryCards: cards,
                            intensity: intensity,
                            count: count,
                            players: players,
                          );
                      context.go('/play');
                    },
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: const TextStyle(color: PlColors.neutralFaint, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600));
}

/// Carte d'aperçu dégradée aux couleurs du jeu (réf. visuelle) — plus la
/// carte blanche d'origine.
class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.gradient, required this.text, required this.intensity});
  final LinearGradient gradient;
  final String? text;
  final int? intensity;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(PlRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text ?? '…',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.35)),
          if (intensity != null) ...[
            const SizedBox(height: 12),
            Text('${intensityLabels[intensity]} · $intensity/5',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12.5)),
          ],
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.selected, required this.gradient, required this.onTap});
  final String label;
  final bool selected;
  final LinearGradient gradient;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : PlColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: selected ? null : Border.all(color: PlColors.hairline),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : PlColors.inkSoft, fontWeight: FontWeight.w700, fontSize: 16)),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: PlColors.surface,
        foregroundColor: PlColors.ink,
        disabledBackgroundColor: PlColors.raised,
        disabledForegroundColor: PlColors.neutralFaint,
        minimumSize: const Size(52, 52),
      ),
    );
  }
}
