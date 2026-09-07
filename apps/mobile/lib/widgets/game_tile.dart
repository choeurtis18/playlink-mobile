import 'package:flutter/material.dart';

import '../data/content_repository.dart';
import '../theme/theme.dart';
import 'pressable.dart';

/// Tuile de la home : le dégradé du jeu contenu à la tuile, sur fond sombre —
/// une affiche qui se détache d'un catalogue (§10). Le `Hero` porte la tuile
/// vers l'en-tête de l'écran du jeu.
class GameTile extends StatelessWidget {
  const GameTile({super.key, required this.game, required this.subtitle, required this.onTap});

  final GameVm game;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      glowColor: hexColor(game.colorMain),
      borderRadius: PlRadius.tile,
      child: Hero(
        tag: 'game-${game.slug}',
        child: Container(
          decoration: BoxDecoration(
            gradient: gameGradient(game.colorMain, game.colorSecondary),
            borderRadius: BorderRadius.circular(PlRadius.tile),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(game.icon ?? '🎲', style: const TextStyle(fontSize: 36)),
              const Spacer(),
              Material(
                type: MaterialType.transparency,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700,
                        height: 1.15, letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
