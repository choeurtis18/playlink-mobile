import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({super.key, required this.emoji, this.size = 44, this.onDark = false});
  final String emoji;
  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onDark ? Colors.white.withValues(alpha: 0.18) : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: onDark ? Colors.white.withValues(alpha: 0.3) : Theme.of(context).dividerColor,
        ),
      ),
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}
