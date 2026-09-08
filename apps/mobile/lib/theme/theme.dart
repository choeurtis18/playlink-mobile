import 'package:flutter/material.dart';

/// Tokens de la direction visuelle (§10) alignés sur le wireframe : un noir
/// teinté indigo comme socle, jamais un gris neutre. Le mode clair existe
/// pour l'accessibilité (F2) mais n'est jamais le défaut.
class PlColors {
  PlColors._();
  static const ground = Color(0xFF0D0C16);
  static const groundDeep = Color(0xFF060509);
  static const surface = Color(0xFF17162A);
  static const raised = Color(0xFF1B1A2B);
  static const raisedHigh = Color(0xFF221F38);
  static const hairline = Color(0xFF2F2D44);
  static const hairlineFirm = Color(0xFF3A3548);
  static const ink = Color(0xFFF3F1EC);
  static const inkSoft = Color(0xFFC7C2D1);
  static const neutral = Color(0xFF948FA3);
  static const neutralFaint = Color(0xFF5C5770);
  static const accent = Color(0xFFF23A6B);
  static const accentDeep = Color(0xFFFF6B93);
  static const success = Color(0xFF4FCE87);
  static const warning = Color(0xFFF5A94E);
  static const danger = Color(0xFFFF6259);
}

/// Rayons : cartes 18, tuiles 16, feuilles 26, pilules 99 (wireframe).
class PlRadius {
  PlRadius._();
  static const tile = 16.0;
  static const card = 18.0;
  static const sheet = 26.0;
  static const pill = 99.0;
}

Color hexColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}

/// Le dégradé d'un jeu — son accent, contenu à sa tuile ou à son écran,
/// jamais en fond d'app (§10).
LinearGradient gameGradient(String colorMain, String colorSecondary) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [hexColor(colorMain), hexColor(colorSecondary)],
  );
}

/// Dégradé d'accent (violet → rose) des CTA hors contexte d'un jeu précis :
/// onboarding, ajout de joueurs — jamais un bouton blanc plein.
const accentGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color(0xFF8B3CF2), PlColors.accent],
);

ThemeData buildDarkTheme() {
  const scheme = ColorScheme.dark(
    primary: PlColors.accent,
    onPrimary: Colors.white,
    secondary: PlColors.accentDeep,
    surface: PlColors.surface,
    onSurface: PlColors.ink,
    error: PlColors.danger,
  );
  return _base(scheme, PlColors.ground, PlColors.hairline, PlColors.inkSoft);
}

ThemeData buildLightTheme() {
  const scheme = ColorScheme.light(
    primary: PlColors.accent,
    onPrimary: Colors.white,
    secondary: PlColors.accentDeep,
    surface: Colors.white,
    onSurface: Color(0xFF15131F),
    error: PlColors.danger,
  );
  return _base(scheme, const Color(0xFFF5F3F8), const Color(0xFFE2DFEA),
      const Color(0xFF4A4658));
}

ThemeData _base(ColorScheme scheme, Color ground, Color hairline, Color soft) {
  final text = ThemeData(brightness: scheme.brightness).textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: ground,
    dividerColor: hairline,
    textTheme: text.copyWith(
      headlineLarge: text.headlineLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.4),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: text.bodyMedium?.copyWith(color: soft, height: 1.45),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlRadius.card),
        side: BorderSide(color: hairline),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: const StadiumBorder(),
        side: BorderSide(color: hairline),
        foregroundColor: scheme.onSurface,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: soft),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        borderSide: BorderSide(color: hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        borderSide: BorderSide(color: hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PlRadius.tile),
        borderSide: const BorderSide(color: PlColors.accent, width: 1.5),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(PlRadius.sheet)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.sheet)),
    ),
  );
}
