import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../theme/theme.dart';

/// A1/A2 : seed SQLite si nécessaire, puis route vers l'onboarding, la liste
/// des joueurs ou la home. Le splash dure au moins 900 ms pour ne pas
/// clignoter quand le seed est instantané.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final Future<void> _minDelay = Future.delayed(const Duration(milliseconds: 900));

  @override
  Widget build(BuildContext context) {
    ref.listen(appBootProvider, (_, next) async {
      if (!next.hasValue) return;
      await _minDelay;
      if (!context.mounted) return;
      final prefs = ref.read(prefsProvider);
      final players = ref.read(playersProvider.notifier).inSession;
      if (!prefs.onboardingSeen) {
        context.go('/onboarding');
      } else if (players.isEmpty) {
        context.go('/players');
      } else {
        context.go('/');
      }
    });

    final boot = ref.watch(appBootProvider);
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: PlColors.ground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 44, color: PlColors.ink, fontWeight: FontWeight.w800),
                  children: const [
                    TextSpan(text: 'Play'),
                    TextSpan(
                      text: 'link',
                      style: TextStyle(
                        color: PlColors.accent,
                        shadows: [Shadow(color: Color(0x80F23A6B), blurRadius: 24)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(t.splashTagline, style: const TextStyle(color: PlColors.neutral)),
            const SizedBox(height: 40),
            if (boot.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text('${boot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: PlColors.danger, fontSize: 12)),
              )
            else
              // Écran toujours sombre (avant chargement des préférences,
              // §10) : `inkSoft` — la même couleur "soft" que le thème
              // sombre applique ailleurs — pas `Theme.of(context)`, jamais
              // pertinent ici.
              Text(t.loadingContent, style: const TextStyle(color: PlColors.inkSoft, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
