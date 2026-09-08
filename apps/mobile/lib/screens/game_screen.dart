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
      return const Scaffold(backgroundColor: PlColors.ground, body: Center(child: CircularProgressIndicator()));
    }
    final cats = ref.watch(categoriesProvider(game.id));
    final players = ref.watch(playersProvider).where((p) => p.inSession).length;

    return GameScaffold(
      colorMain: game.colorMain,
      colorSecondary: game.colorSecondary,
      heroTag: 'game-${game.slug}',
      headerHeight: 168,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _PillButton(
              icon: Icons.menu_book_rounded,
              label: t.rules,
              onTap: () => showRulesSheet(context, game),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.icon ?? '', style: const TextStyle(fontSize: 34)),
                const SizedBox(height: 6),
                Text(game.name,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                const SizedBox(height: 4),
                Text(
                  '${game.categoryCount} ${t.categoriesTitle.toLowerCase()} · ${t.cardsCount(game.cardCount)} · $players 👥',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(t.chooseCategory.toUpperCase(),
                style: const TextStyle(color: PlColors.neutralFaint, fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
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
                        color: PlColors.surface,
                        borderRadius: BorderRadius.circular(PlRadius.tile),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: PlColors.raisedHigh,
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
                                Text('${t.cardsCount(c.cardCount)} · ${t.intensity.toLowerCase()} 1–5',
                                    style: const TextStyle(color: PlColors.neutralFaint, fontSize: 12.5)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: PlColors.neutralFaint),
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

class _PillButton extends StatelessWidget {
  const _PillButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
