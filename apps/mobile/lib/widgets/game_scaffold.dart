import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Écrans DU jeu (page, config, tour, vote, résultats) : contrairement à
/// l'hypothèse initiale du §10, la référence visuelle (Claude Design) montre
/// un dégradé confiné à un BANDEAU d'en-tête, jamais plein écran — le tour du
/// joueur, le vote et les résultats sont sur fond sombre uni. Seul le
/// bandeau (icône, nom, sous-titre) porte la couleur du jeu.
class GameScaffold extends StatelessWidget {
  const GameScaffold({
    super.key,
    required this.colorMain,
    required this.colorSecondary,
    required this.body,
    this.appBar,
    this.heroTag,
    this.headerHeight = 220,
  });

  final String colorMain;
  final String colorSecondary;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final String? heroTag;
  /// Hauteur du bandeau dégradé derrière l'appBar. 0 = fond sombre uni
  /// (tour du joueur, carte, vote, passe-le-téléphone, résultats).
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final header = DecoratedBox(
      decoration: BoxDecoration(gradient: gameGradient(colorMain, colorSecondary)),
      child: SizedBox(height: headerHeight, width: double.infinity),
    );
    return Scaffold(
      backgroundColor: PlColors.ground,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (headerHeight > 0)
            Align(
              alignment: Alignment.topCenter,
              child: heroTag == null ? header : Hero(tag: heroTag!, child: header),
            ),
          SafeArea(child: body),
        ],
      ),
    );
  }
}

/// CTA principal des écrans de jeu : dégradé de la couleur du jeu — jamais
/// un bouton blanc plein (référence visuelle, tous les écrans).
class OnGradientButton extends StatelessWidget {
  const OnGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.colorMain,
    this.colorSecondary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? colorMain;
  final String? colorSecondary;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final gradient = colorMain != null && colorSecondary != null
        ? gameGradient(colorMain!, colorSecondary!)
        : accentGradient;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(PlRadius.pill)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(PlRadius.pill),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, color: Colors.white, size: 20), const SizedBox(width: 8)],
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Action secondaire sombre — utilisé sur fond sombre uni (résultats,
/// « Partager le score » / « Accueil »).
class GhostButton extends StatelessWidget {
  const GhostButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: PlColors.ink,
        backgroundColor: PlColors.surface,
        side: const BorderSide(color: PlColors.hairlineFirm),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PlRadius.pill)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

/// CTA d'accent (violet → rose) hors contexte de jeu : onboarding, joueurs.
class AccentButton extends StatelessWidget {
  const AccentButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: accentGradient, borderRadius: BorderRadius.circular(PlRadius.pill)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(PlRadius.pill),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, color: Colors.white, size: 20), const SizedBox(width: 8)],
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
