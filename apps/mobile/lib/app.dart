import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/auth_config.dart';
import 'data/clerk_error_handler.dart';
import 'data/providers.dart';
import 'router.dart';
import 'theme/theme.dart';

class PlaylinkApp extends ConsumerWidget {
  const PlaylinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = switch (ref.watch(prefsProvider).themeMode) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark, // sombre-first : jamais le clair par défaut (§10)
    };
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: themeMode == ThemeMode.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: MaterialApp.router(
        title: 'Playlink',
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: themeMode,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: ref.watch(routerProvider),
        // Sans clé Clerk fournie au build (dev avant configuration de
        // l'instance, ou build hors-ligne pur) : pas de `builder`, l'app
        // reste utilisable normalement — seule la connexion réelle
        // (§ compte, phase 4) reste indisponible, jamais un crash.
        // Équivalent de `ClerkAuth.materialAppBuilder`, au `handler` près :
        // celui-ci neutralise les messages d'erreur qui révèleraient
        // l'existence d'un compte (voir clerk_error_handler.dart).
        builder: clerkConfigured
            ? (context, child) => ClerkAuth(
                  config: buildClerkConfig(),
                  child: ClerkErrorListener(handler: handleClerkError, child: child!),
                )
            : null,
      ),
    );
  }
}
