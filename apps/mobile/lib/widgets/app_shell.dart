import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// Coquille avec barre de navigation basse — Jeux / Classement / Profil
/// (réf. visuelle, absente du blueprint initial). Suit le thème clair/sombre
/// (F2) plutôt que des couleurs codées en dur, icône + libellé, l'onglet
/// actif surligné du même dégradé que `homeTitleHighlight`.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.sports_esports_rounded,
                  label: t.navPlay,
                  selected: navigationShell.currentIndex == 0,
                  onTap: () => navigationShell.goBranch(0),
                ),
                _NavItem(
                  icon: Icons.emoji_events_rounded,
                  label: t.navLeaderboard,
                  selected: navigationShell.currentIndex == 1,
                  onTap: () => navigationShell.goBranch(1),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: t.navProfile,
                  selected: navigationShell.currentIndex == 2,
                  onTap: () => navigationShell.goBranch(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unselected = Theme.of(context).textTheme.bodyMedium?.color ?? PlColors.neutral;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          // Le focus englobe icône ET libellé (une seule pilule), pas
          // juste l'icône — demandé pour lire le focus d'un coup d'œil.
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: selected ? accentGradient : null,
              borderRadius: BorderRadius.circular(PlRadius.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: selected ? Colors.white : unselected, size: 18),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.white : unselected,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
