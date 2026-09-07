import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Toute tuile interactive répond au toucher par un scale + un glow de la
/// couleur du jeu — jamais un aplat gris (§10). Appui : 0.97, relâchement :
/// rebond court avec léger dépassement.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.glowColor,
    this.borderRadius = 16,
    this.haptic = true,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color? glowColor;
  final double borderRadius;
  final bool haptic;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final glow = widget.glowColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: () {
        if (widget.haptic) HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: Duration(milliseconds: _down ? 90 : 160),
        curve: _down ? Curves.easeOut : Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: glow == null
                ? null
                : [
                    BoxShadow(
                      color: glow.withValues(alpha: _down ? 0.55 : 0.28),
                      blurRadius: _down ? 26 : 18,
                      spreadRadius: _down ? 2 : 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
