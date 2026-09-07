import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ),
    );
  }
}
