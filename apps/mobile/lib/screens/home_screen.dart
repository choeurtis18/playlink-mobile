import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/content_repository.dart';
import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_tile.dart';
import 'players_screen.dart';

final _gamesProvider = FutureProvider<List<GameVm>>((ref) {
  final locale = ref.watch(localeProvider).languageCode;
  return ref.watch(contentRepositoryProvider).games(locale);
});

/// B1 : grille des 8 jeux sur fond sombre + CTA joueurs (modale, sans
/// quitter la home).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openPlayers(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: PlayersEditor(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final games = ref.watch(_gamesProvider);
    final count = ref.watch(playersProvider).where((p) => p.inSession).length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(child: Text(t.homeTitle, style: Theme.of(context).textTheme.headlineMedium)),
                    ActionChip(
                      avatar: const Icon(Icons.group, size: 18),
                      label: Text(t.playersButton(count)),
                      onPressed: () => _openPlayers(context),
                      backgroundColor: PlColors.surface,
                      side: const BorderSide(color: PlColors.hairline),
                      shape: const StadiumBorder(),
                    ),
                  ],
                ),
              ),
            ),
            games.when(
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              error: (e, _) => SliverFillRemaining(child: Center(child: Text('$e'))),
              data: (list) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.88,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => GameTile(
                      game: list[i],
                      subtitle: t.cardsCount(list[i].cardCount),
                      onTap: () => context.push('/game/${list[i].slug}'),
                    ),
                    childCount: list.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
