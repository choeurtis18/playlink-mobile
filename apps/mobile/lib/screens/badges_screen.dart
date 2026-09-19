import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/badges_repository.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

// `autoDispose` : sans lui, ce provider ne se recalcule JAMAIS une fois lu
// une première fois (ex. un tour de curiosité sur cet écran avant de
// jouer) — l'écran resterait figé sur « tout verrouillé » pour le reste
// de la session, même après un badge réellement débloqué en base.
final badgesListProvider = FutureProvider.autoDispose<List<BadgeVm>>((ref) {
  final locale = ref.watch(localeProvider).languageCode;
  return ref.watch(badgesRepositoryProvider).all(locale);
});

/// D4 : grille des badges gagnés + verrouillés (avec la condition),
/// évalués localement en fin de partie (§01/§09) — accessible depuis le
/// profil.
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final badges = ref.watch(badgesListProvider);
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(t.badgesTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.badgesSubtitle, style: TextStyle(color: soft, fontSize: 13)),
              const SizedBox(height: 16),
              Expanded(
                child: badges.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (list) => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _BadgeTile(badge: list[i]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});
  final BadgeVm badge;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? scheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(PlRadius.card),
        border: Border.all(color: badge.earned ? Colors.transparent : Theme.of(context).dividerColor),
      ),
      child: Opacity(
        opacity: badge.earned ? 1 : 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: badge.earned ? accentGradient : null,
                color: badge.earned ? null : (scheme.brightness == Brightness.dark ? PlColors.raisedHigh : scheme.surfaceContainerHighest),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(badge.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 12),
            Text(badge.name,
                maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            // Description masquée tant que le badge n'est pas débloqué —
            // titre + image suffisent à teaser le badge verrouillé.
            if (badge.earned) ...[
              const SizedBox(height: 4),
              Text(badge.description,
                  maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: soft, fontSize: 11.5)),
            ],
            const SizedBox(height: 6),
            Text(
              badge.earned && badge.earnedAt != null ? t.badgeEarnedOn(_formatDate(badge.earnedAt!)) : t.badgeLocked,
              style: TextStyle(
                color: badge.earned ? PlColors.success : soft,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
