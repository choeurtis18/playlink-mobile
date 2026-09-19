import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/content_repository.dart';
import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_tile.dart';
import 'players_screen.dart';

final gamesProvider = FutureProvider<List<GameVm>>((ref) {
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
    final games = ref.watch(gamesProvider);
    final players = ref.watch(playersProvider).where((p) => p.inSession).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const _BrandMark(),
                    const Spacer(),
                    _AccountButton(state: ref.watch(prefsProvider).accountState),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              sliver: SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PlRadius.tile),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: _PlayersChip(players: players, onTap: () => _openPlayers(context)),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              sliver: SliverToBoxAdapter(
                child: _HomeTitle(start: t.homeTitleStart_1, highlight: t.homeTitleHighlight, end: t.homeTitleStart_2),
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
                      subtitle: t.categoriesCount(list[i].categoryCount),
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

/// Titre en deux temps (même motif que `_PlayersTitle` sur l'écran joueurs) :
/// texte fixe, puis la partie soulignée par l'utilisateur sur une pilule au
/// dégradé accent.
class _HomeTitle extends StatelessWidget {
  const _HomeTitle({required this.start, required this.highlight, required this.end});
  final String start, highlight, end;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        Text(start, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
        DecoratedBox(
          decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.tile)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              highlight,
              style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4, color: Colors.white,
              ),
            ),
          ),
        ),
        Text(end, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
      ],
    );
  }
}

/// "PLAYLINK" — texte plus lisible qu'un petit label discret, dégradé
/// d'accent pour rester dans l'identité de l'app plutôt qu'un gris neutre.
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => accentGradient.createShader(bounds),
      child: const Text('PLAYLINK',
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
    );
  }
}

/// Façade de démo tant que Clerk/RevenueCat ne sont pas construits (voir
/// `AccountState`) : invité → « Se connecter », connecté non-premium →
/// « Devenir premium », premium → rien à afficher. Le tap fait juste
/// avancer l'état local d'un cran et annonce « Bientôt disponible » — aucun
/// vrai compte ni abonnement derrière.
class _AccountButton extends ConsumerWidget {
  const _AccountButton({required this.state});
  final AccountState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state == AccountState.premium) return const SizedBox.shrink();
    final t = AppLocalizations.of(context);
    final label = state == AccountState.guest ? t.signIn : t.goPremium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.pill),
        onTap: () {
          final next = state == AccountState.guest ? AccountState.free : AccountState.premium;
          ref.read(prefsProvider.notifier).set(PrefKeys.accountState, next.name);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(t.comingSoon)));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.pill)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
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
    // Résumé, pas la liste complète : au-delà de 2 joueurs, les avatars et
    // noms des suivants sont condensés en "…" — le détail est à un tap
    // (`onTap` ouvre l'édition complète).
    final shown = players.take(2).toList();
    final overflowCount = players.length - shown.length;
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(PlRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Text(
                overflowCount > 0
                    ? '${shown.map((p) => p.avatar).join(' ')} …'
                    : shown.map((p) => p.avatar).join(' '),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.playersButton(players.length), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(
                      overflowCount > 0
                          ? '${shown.map((p) => p.name).join(', ')}…'
                          : shown.map((p) => p.name).join(', '),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: soft, fontSize: 12),
                    ),
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
