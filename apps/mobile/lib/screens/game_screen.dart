import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/content_repository.dart';
import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';
import '../widgets/pressable.dart';
import 'rules_sheet.dart';

final gameBySlugProvider = FutureProvider.family<GameVm?, String>((ref, slug) {
  final locale = ref.watch(localeProvider).languageCode;
  return ref.watch(contentRepositoryProvider).gameBySlug(slug, locale);
});

final categoriesProvider = FutureProvider.family<List<CategoryVm>, String>((ref, gameId) {
  final locale = ref.watch(localeProvider).languageCode;
  return ref.watch(contentRepositoryProvider).categories(gameId, locale);
});

/// B1 · page du jeu : bandeau dégradé compact (icône, nom, sous-titre),
/// puis la liste des catégories sur fond sombre — la tuile s'étend en Hero
/// jusqu'à ce bandeau, il ne couvre pas tout l'écran (réf. visuelle).
class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final game = ref.watch(gameBySlugProvider(slug)).value;
    if (game == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cats = ref.watch(categoriesProvider(game.id));
    final players = ref.watch(playersProvider).where((p) => p.inSession).length;
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;

    return GameScaffold(
      colorMain: game.colorMain,
      colorSecondary: game.colorSecondary,
      heroTag: 'game-${game.slug}',
      headerHeight: 300,
      headerGradientVertical: true,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
            // Niveau 2 : icône, nom, sous-titre du jeu.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(game.icon ?? '', style: const TextStyle(fontSize: 34)),
                const SizedBox(height: 12),
                Text(game.name,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                const SizedBox(height: 6),
                Text(
                  '${game.categoryCount} ${t.categoriesTitle.toLowerCase()} · $players 👥',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(t.chooseCategory.toUpperCase(),
                style: TextStyle(color: soft, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: cats.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (list) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final c = list[i];
                  return Pressable(
                    onTap: () => context.push('/game/${game.slug}/config/${c.id}'),
                    borderRadius: PlRadius.tile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(PlRadius.tile),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? PlColors.raisedHigh
                                  : Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Text(c.icon ?? '🃏', style: const TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                Text('${t.intensity.toLowerCase()} 1–5',
                                    style: TextStyle(color: soft, fontSize: 12.5)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: soft),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
