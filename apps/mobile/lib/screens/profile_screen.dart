import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Text(t.profileTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(t.profileLocalMode, style: TextStyle(color: soft, fontSize: 13)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(PlRadius.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.profileLocalCardTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(t.profileLocalCardBody, style: TextStyle(color: soft, fontSize: 13.5, height: 1.4)),
                  const SizedBox(height: 14),
                  // Même style dégradé que le CTA "Se connecter" de l'accueil
                  // (`_AccountButton`) — un seul traitement visuel pour
                  // l'action compte dans toute l'app.
                  DecoratedBox(
                    decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.pill)),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: null,
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.pill)),
                        ),
                        child: Text(t.createAccount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Badges et cartes perso fonctionnent 100 % en local (D4, C1-C3)
            // — contrairement aux likes, qui exigent un compte (E1, phase 5).
            _Row(icon: Icons.emoji_events_rounded, label: t.badgesTitle, sublabel: null, onTap: () => context.push('/badges')),
            const SizedBox(height: 10),
            _Row(icon: Icons.style_rounded, label: t.myCards, sublabel: null, onTap: () => context.push('/my-cards')),
            const SizedBox(height: 10),
            _Row(icon: Icons.favorite_rounded, label: t.likedCards, sublabel: null),
            const SizedBox(height: 10),
            _Row(icon: Icons.settings_rounded, label: t.settings, sublabel: t.settingsSubtitle, onTap: () => context.push('/settings')),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, required this.sublabel, this.onTap});
  final IconData icon;
  final String label;
  final String? sublabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final soft = Theme.of(context).textTheme.bodyMedium?.color ?? scheme.onSurface;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(PlRadius.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.brightness == Brightness.dark ? PlColors.raisedHigh : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: scheme.onSurface),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    if (sublabel != null)
                      Text(sublabel!, style: TextStyle(color: soft, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: soft),
            ],
          ),
        ),
      ),
    );
  }
}
