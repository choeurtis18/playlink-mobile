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
import 'rules_sheet.dart';

/// Pool de tirage d'une catégorie : cartes officielles + cartes perso
/// ACTIVES de l'appareil (C2 — « entre automatiquement dans le pool »).
/// Une carte perso n'a pas de tags (pas de champ au formulaire, §14 C1) :
/// elle ne contribue ni à l'archétype ni à `truth_seeker`.
final _cardsProvider = FutureProvider.family<List<CardVm>, String>((ref, categoryId) async {
  final locale = ref.watch(localeProvider).languageCode;
  final official = await ref.watch(contentRepositoryProvider).cards(categoryId, locale);
  final custom = await ref.watch(customCardsRepositoryProvider).activeFor(categoryId);
  return [
    ...official,
    for (final c in custom)
      CardVm(id: c.id, categoryId: c.categoryId, text: c.text, intensity: c.intensity, tags: const [], canonicalTags: const []),
  ];
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
  /// Carte d'aperçu tirée une fois par intensité (clé = intensité), pas à
  /// chaque rebuild ni à chaque changement de segment : changer l'intensité
  /// doit montrer une carte de cette intensité, mais toujours la MÊME au fil
  /// des allers-retours — sinon parcourir les 5 segments revient à parcourir
  /// toutes les cartes de la catégorie depuis cet écran seul.
  final Map<int, int> _previewIndexByIntensity = {};

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final game = ref.watch(gameBySlugProvider(widget.slug)).value;
    if (game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final category = ref.watch(categoriesProvider(game.id)).value
        ?.firstWhere((c) => c.id == widget.categoryId);
    final cards = ref.watch(_cardsProvider(widget.categoryId)).value ?? const <CardVm>[];
    final prefs = ref.watch(prefsProvider);
    final intensity = prefs.intensityFor(game.id);
    final count = prefs.cardsPerGame;
    final players = ref.watch(playersProvider).where((p) => p.inSession).toList();

    // Aperçu stable par intensité : tiré une fois par valeur d'intensité
    // (pas à chaque rebuild), parmi les cartes de CETTE intensité exacte —
    // avec repli sur la plus proche si aucune n'y correspond exactement.
    if (cards.isNotEmpty && !_previewIndexByIntensity.containsKey(intensity)) {
      final exact = <int>[
        for (var i = 0; i < cards.length; i++)
          if (cards[i].intensity == intensity) i,
      ];
      _previewIndexByIntensity[intensity] = exact.isNotEmpty
          ? exact[Random().nextInt(exact.length)]
          : (List<int>.generate(cards.length, (i) => i)
                ..sort((a, b) =>
                    (cards[a].intensity - intensity).abs().compareTo((cards[b].intensity - intensity).abs())))
              .first;
    }
    final previewIndex = _previewIndexByIntensity[intensity];
    final preview = previewIndex == null || cards.isEmpty ? null : cards[previewIndex];
    final gradient = gameGradient(game.colorMain, game.colorSecondary, vertical: true);

    return GameScaffold(
      colorMain: game.colorMain,
      colorSecondary: game.colorSecondary,
      headerHeight: 180,
      headerGradientVertical: true,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Niveau 1 : retour + règles, alignés aux extrémités.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleButton(icon: Icons.arrow_back_rounded, onTap: () => popOrHome(context)),
                PillButton(
                  icon: Icons.menu_book_rounded,
                  label: t.rules,
                  onTap: () => showRulesSheet(context, game),
                ),
              ],
            ),
            // Niveau 2 : jeu puis catégorie.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(game.name.toUpperCase(),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(category?.name ?? '',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -0.4)),
              ],
            ),
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
                  Builder(builder: (context) {
                    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
                    return Text(intensityLabels[intensity]!, style: TextStyle(color: soft, fontWeight: FontWeight.w600));
                  }),
                  const SizedBox(height: 26),
                  _Label(t.cardsPerGame),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 0; i < cardsPerGameOptions.length; i++) ...[
                        Expanded(
                          child: _Segment(
                            label: '${cardsPerGameOptions[i]}',
                            selected: cardsPerGameOptions[i] == count,
                            gradient: gradient,
                            onTap: () => ref
                                .read(prefsProvider.notifier)
                                .set(PrefKeys.cardsPerGame, '${cardsPerGameOptions[i]}'),
                          ),
                        ),
                        if (i < cardsPerGameOptions.length - 1) const SizedBox(width: 6),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    // Résumé, pas la liste complète : au-delà de 2 joueurs,
                    // avatars et noms des suivants sont condensés en "…".
                    final shown = players.take(2).toList();
                    final overflow = players.length - shown.length;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(PlRadius.tile),
                      ),
                      child: Row(
                        children: [
                          Text(
                            overflow > 0 ? '${shown.map((p) => p.avatar).join(' ')} …' : shown.map((p) => p.avatar).join(' '),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              overflow > 0 ? '${shown.map((p) => p.name).join(', ')}…' : shown.map((p) => p.name).join(', '),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
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
  Widget build(BuildContext context) {
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Text(text.toUpperCase(),
        style: TextStyle(color: soft, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600));
  }
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
    final theme = Theme.of(context);
    final soft = theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: selected ? null : Border.all(color: theme.dividerColor),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : soft, fontWeight: FontWeight.w700, fontSize: 16)),
      ),
    );
  }
}
