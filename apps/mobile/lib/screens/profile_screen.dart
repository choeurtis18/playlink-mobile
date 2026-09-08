import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// D1 : profil du compte — en V1 sans compte, l'écran explique le mode local
/// et donne accès à ce qui n'a besoin de rien d'autre (§00). Les cartes
/// personnalisées et les likes exigent un compte (C1, E1) et n'ont donc pas
/// encore de contenu à afficher tant qu'ils ne sont pas construits.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: PlColors.ground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Text(t.profileTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(t.profileLocalMode, style: const TextStyle(color: PlColors.neutralFaint, fontSize: 13)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: PlColors.surface,
                borderRadius: BorderRadius.circular(PlRadius.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.profileLocalCardTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(t.profileLocalCardBody, style: const TextStyle(color: PlColors.inkSoft, fontSize: 13.5, height: 1.4)),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PlColors.accent,
                      side: const BorderSide(color: PlColors.accent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.pill)),
                    ),
                    child: Text(t.createAccount),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _Row(icon: Icons.style_rounded, label: t.myCards, sublabel: null),
            const SizedBox(height: 10),
            _Row(icon: Icons.favorite_rounded, label: t.likedCards, sublabel: null),
            const SizedBox(height: 10),
            _Row(icon: Icons.settings_rounded, label: t.settings, sublabel: t.settingsSubtitle),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.sublabel});
  final IconData icon;
  final String label;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: PlColors.surface,
        borderRadius: BorderRadius.circular(PlRadius.tile),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: PlColors.raisedHigh, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: PlColors.inkSoft),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                if (sublabel != null)
                  Text(sublabel!, style: const TextStyle(color: PlColors.neutralFaint, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: PlColors.neutralFaint),
        ],
      ),
    );
  }
}
