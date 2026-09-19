import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme.dart';

/// Retour vers l'écran précédent — ou l'accueil si la pile de navigation
/// n'en a pas (accès direct, deep link, ou pile vidée par un `context.go`
/// antérieur) : jamais un bouton retour qui ne fait rien.
void popOrHome(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    context.go('/');
  }
}

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
    this.header,
    this.heroTag,
    this.headerHeight = 220,
    this.headerGradientVertical = false,
    this.backgroundColor,
  });

  final String colorMain;
  final String colorSecondary;
  final Widget body;
  final PreferredSizeWidget? appBar;
  /// Contenu custom du bandeau, fixe (ne scrolle pas avec `body`) — pour un
  /// header à plusieurs niveaux qu'un `AppBar` standard ne peut pas rendre
  /// fidèlement. Remplace `appBar` quand fourni.
  final Widget? header;
  final String? heroTag;
  /// Hauteur du bandeau dégradé derrière l'appBar/header. 0 = fond sombre
  /// uni (tour du joueur, carte, vote, passe-le-téléphone, résultats).
  final double headerHeight;
  /// true : dégradé du bandeau haut → bas plutôt que la diagonale par
  /// défaut de `gameGradient` (réservée aux tuiles/accents ailleurs dans
  /// l'app, §10) — demandé spécifiquement pour ce bandeau plein-largeur.
  final bool headerGradientVertical;
  /// Couleur derrière la zone status bar/AppBar (`extendBodyBehindAppBar`) —
  /// visible en filigrane à travers l'AppBar transparente tant que `body` ne
  /// peint pas jusque-là (le `SafeArea` ci-dessous réserve cet espace). Sans
  /// ça, cette bande reprend le fond du thème même sur un écran dont le
  /// contenu est un dégradé plein écran (passe-le-téléphone) : `PlayScreen`
  /// la fixe à `colorMain` sur ce seul écran.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final gradient = gameGradient(colorMain, colorSecondary);
    final decoration = BoxDecoration(
      gradient: headerGradientVertical
          ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: gradient.colors)
          : gradient,
    );
    final band = DecoratedBox(
      decoration: decoration,
      child: SizedBox(height: headerHeight, width: double.infinity),
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: header == null ? appBar : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (header != null)
            // Bandeau + contenu fixe dans un seul conteneur (pas d'AppBar
            // Material ici) : le body scrolle sous lui, jamais l'inverse.
            Align(
              alignment: Alignment.topCenter,
              child: Builder(builder: (context) {
                final band = DecoratedBox(
                  decoration: decoration,
                  child: SizedBox(
                    height: headerHeight,
                    width: double.infinity,
                    child: SafeArea(bottom: false, child: header!),
                  ),
                );
                return heroTag == null ? band : Hero(tag: heroTag!, child: band);
              }),
            )
          else if (headerHeight > 0)
            Align(
              alignment: Alignment.topCenter,
              child: heroTag == null ? band : Hero(tag: heroTag!, child: band),
            ),
          Positioned.fill(
            child: header == null
                ? SafeArea(child: body)
                : Padding(
                    padding: EdgeInsets.only(top: headerHeight),
                    child: body,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Bouton retour rond, translucide sur le dégradé — même esprit que
/// `PillButton` (Règles), mais icône seule. Partagé par tous les bandeaux
/// dégradés (page jeu, config…).
class CircleButton extends StatelessWidget {
  const CircleButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

/// Pilule translucide (icône + libellé) sur un bandeau dégradé — CTA
/// « Règles » notamment.
class PillButton extends StatelessWidget {
  const PillButton({super.key, required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
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
        ? gameGradient(colorMain!, colorSecondary!, vertical: true)
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
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.onSurface,
        backgroundColor: scheme.surface,
        side: BorderSide(color: Theme.of(context).dividerColor),
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
