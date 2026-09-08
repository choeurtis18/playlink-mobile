import 'package:flutter/material.dart';

/// Avatar rond d'un joueur. `gradient` (couleur du jeu) prime sur `onDark` —
/// utilisé sur les écrans de tour/passe où l'avatar porte le dégradé du
/// jeu (réf. visuelle), sinon un cercle sombre uni.
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    super.key,
    required this.emoji,
    this.size = 44,
    this.onDark = false,
    this.gradient,
  });
  final String emoji;
  final double size;
  final bool onDark;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        color: gradient != null
            ? null
            : (onDark ? Colors.white.withValues(alpha: 0.18) : Theme.of(context).colorScheme.surface),
        border: gradient != null
            ? null
            : Border.all(color: onDark ? Colors.white.withValues(alpha: 0.3) : Theme.of(context).dividerColor),
      ),
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}
