import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// Coquille avec barre de navigation basse — Jouer / Classement / Profil
/// (réf. visuelle, absente du blueprint initial). Fond quasi transparent sur
/// noir, icône + libellé, l'onglet actif en accent.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: PlColors.ground,
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: PlColors.groundDeep,
          border: Border(top: BorderSide(color: PlColors.hairline)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 58,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.casino_rounded,
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
    final color = selected ? PlColors.accent : PlColors.neutralFaint;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
