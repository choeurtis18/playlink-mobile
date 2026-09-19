import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../theme/theme.dart';
import '../widgets/game_scaffold.dart';

/// A1 : trois écrans — comment on joue, le compte optionnel, le consentement
/// analytics (opt-in explicite, §08). Barre de progression en segments
/// (haut), bouton dégradé accent, lien « Passer » (réf. visuelle). Le
/// consentement est un toggle sur un écran normal — pas deux boutons
/// séparés Accepter/Refuser — activé par défaut, pour ne pas forcer de
/// choix binaire bloquant.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;
  bool _analyticsConsent = true;

  Future<void> _finish() async {
    final prefs = ref.read(prefsProvider.notifier);
    await prefs.set(PrefKeys.analyticsConsent, _analyticsConsent ? '1' : '0');
    await prefs.set(PrefKeys.onboardingSeen, '1');
    if (mounted) context.go('/players');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final pages = [
      ('🎲', t.onboardingHowTitle, t.onboardingHowBody),
      ('🔓', t.onboardingAccountTitle, t.onboardingAccountBody),
      ('📊', t.onboardingAnalyticsTitle, t.onboardingAnalyticsBody),
    ];
    final last = _page == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  for (var i = 0; i < pages.length; i++) ...[
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _page ? PlColors.accent : PlColors.hairlineFirm,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < pages.length - 1) const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final (icon, title, body) = pages[i];
                  final showConsent = i == pages.length - 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(icon, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 24),
                        Text(title, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 12),
                        Text(body, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PlColors.inkSoft)),
                        if (showConsent) ...[
                          const SizedBox(height: 20),
                          _ConsentToggle(
                            value: _analyticsConsent,
                            onChanged: (v) => setState(() => _analyticsConsent = v),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: AccentButton(
                label: last ? t.onboardingStart : t.next,
                onPressed: last
                    ? _finish
                    : () => _ctrl.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextButton(
                onPressed: _finish,
                child: Text(t.skip, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentToggle extends StatelessWidget {
  const _ConsentToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(PlRadius.tile),
      ),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: PlColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.onboardingAnalyticsToggleTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
