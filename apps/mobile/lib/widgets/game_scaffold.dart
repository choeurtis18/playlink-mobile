import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Écrans DU jeu (page, config, partie) : le dégradé plein écran du jeu reste
/// l'accent immersif propre à chaque jeu (§10). Le sombre l'encadre, ne le
/// concurrence pas.
class GameScaffold extends StatelessWidget {
  const GameScaffold({
    super.key,
    required this.colorMain,
    required this.colorSecondary,
    required this.body,
    this.appBar,
    this.heroTag,
  });

  final String colorMain;
  final String colorSecondary;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final background = DecoratedBox(
      decoration: BoxDecoration(gradient: gameGradient(colorMain, colorSecondary)),
      child: const SizedBox.expand(),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          heroTag == null ? background : Hero(tag: heroTag!, child: background),
          // Voile sombre en bas : les textes et boutons restent lisibles
          // quelle que soit la clarté du dégradé.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x66000000)],
                stops: [0.45, 1],
              ),
            ),
          ),
          SafeArea(child: body),
        ],
      ),
    );
  }
}

/// Bouton blanc sur dégradé — le CTA des écrans de jeu.
class OnGradientButton extends StatelessWidget {
  const OnGradientButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF15131F),
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.4),
      ),
      icon: icon == null ? const SizedBox.shrink() : Icon(icon),
      label: Text(label),
    );
  }
}

/// Bouton translucide sur dégradé — action secondaire.
class GhostButton extends StatelessWidget {
  const GhostButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white.withValues(alpha: 0.14),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Text(label),
    );
  }
}
