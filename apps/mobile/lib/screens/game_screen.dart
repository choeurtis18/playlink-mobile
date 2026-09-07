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

/// B1 · page du jeu : la tuile s'est étendue en écran (Hero), ses catégories
/// et l'accès aux règles.
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

    return GameScaffold(
      colorMain: game.colorMain,
      colorSecondary: game.colorSecondary,
      heroTag: 'game-${game.slug}',
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: const BackButton(),
        actions: [
          IconButton(
            tooltip: t.rules,
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () => showRulesSheet(context, game),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.icon ?? '', style: const TextStyle(fontSize: 52)),
                const SizedBox(height: 8),
                Text(game.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                if (game.description != null) ...[
                  const SizedBox(height: 8),
                  Text(game.description!,
                      maxLines: 4, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.4)),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(t.chooseCategory.toUpperCase(),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: cats.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
              error: (e, _) => Center(child: Text('$e', style: const TextStyle(color: Colors.white))),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(PlRadius.tile),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: Row(
                        children: [
                          Text(c.icon ?? '🃏', style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                                Text(t.cardsCount(c.cardCount), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.5)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.7)),
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
