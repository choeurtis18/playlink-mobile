import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../theme/theme.dart';

/// A1 : trois écrans — comment on joue, le compte optionnel, le consentement
/// analytics (opt-in explicite, §08).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  Future<void> _finish(bool analytics) async {
    final prefs = ref.read(prefsProvider.notifier);
    await prefs.set(PrefKeys.analyticsConsent, analytics ? '1' : '0');
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
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final (icon, title, body) = pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(icon, style: const TextStyle(fontSize: 64)),
                        const SizedBox(height: 24),
                        Text(title, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 12),
                        Text(body, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PlColors.inkSoft)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page ? PlColors.accent : PlColors.hairlineFirm,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: last
                  ? Column(
                      children: [
                        FilledButton(onPressed: () => _finish(true), child: Text(t.onboardingAnalyticsAccept)),
                        const SizedBox(height: 10),
                        OutlinedButton(onPressed: () => _finish(false), child: Text(t.onboardingAnalyticsDecline)),
                      ],
                    )
                  : FilledButton(
                      onPressed: () => _ctrl.nextPage(
                          duration: const Duration(milliseconds: 260), curve: Curves.easeOut),
                      child: Text(t.next),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
