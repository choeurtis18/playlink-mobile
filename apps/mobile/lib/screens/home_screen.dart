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
/// quitter la home). Badge « Hors-ligne prêt » (réf. visuelle) : rappelle
/// que l'app fonctionne sans réseau, sans que ce soit un état d'erreur.
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
    final players = ref.watch(playersProvider).where((p) => p.inSession).toList();

    return Scaffold(
      backgroundColor: PlColors.ground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Text('PLAYLINK',
                        style: TextStyle(color: PlColors.neutralFaint, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    const Spacer(),
                    const _OfflineBadge(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              sliver: SliverToBoxAdapter(
                child: _PlayersChip(players: players, onTap: () => _openPlayers(context)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              sliver: SliverToBoxAdapter(
                child: Text(t.homeTitle, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
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

class _OfflineBadge extends StatelessWidget {
  const _OfflineBadge();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, height: 6,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: PlColors.success),
        ),
        const SizedBox(width: 6),
        Text(t.offlineReady, style: const TextStyle(color: PlColors.success, fontSize: 11.5, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PlayersChip extends StatelessWidget {
  const _PlayersChip({required this.players, required this.onTap});
  final List players;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Material(
      color: PlColors.surface,
      borderRadius: BorderRadius.circular(PlRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Text(players.map((p) => p.avatar).join(' '), style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.playersButton(players.length), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(players.map((p) => p.name).join(', '),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: PlColors.neutralFaint, fontSize: 12)),
                  ],
                ),
              ),
              Text(t.playersEdit, style: const TextStyle(color: PlColors.accentDeep, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
