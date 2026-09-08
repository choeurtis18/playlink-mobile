import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// PlayCard : pile de cartes swipeable, dégradée aux couleurs du jeu
/// (réf. visuelle — plus une carte blanche).
///
/// Sur mobile le vote est obligatoire pour avancer (B5) : un swipe vers la
/// droite au-delà du seuil (±80 px, comme le web) n'avance donc pas la carte,
/// il ouvre le vote — la seule voie possible. Un swipe vers la gauche revient
/// à sa place : on ne rejoue pas une carte déjà votée.
class PlayCard extends StatefulWidget {
  const PlayCard({
    super.key,
    required this.text,
    required this.intensityLabel,
    required this.gradient,
    required this.behind,
    required this.onSwipeToVote,
    this.categoryLabel,
  });

  final String text;
  final String intensityLabel;
  final Gradient gradient;
  final String? categoryLabel;
  /// Nombre de cartes restantes derrière (0–2 fantômes affichés).
  final int behind;
  final VoidCallback onSwipeToVote;

  @override
  State<PlayCard> createState() => _PlayCardState();
}

class _PlayCardState extends State<PlayCard> with SingleTickerProviderStateMixin {
  static const threshold = 80.0;
  double _dx = 0;
  late final AnimationController _spring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );
  Animation<double>? _settle;

  @override
  void dispose() {
    _spring.dispose();
    super.dispose();
  }

  void _end(DragEndDetails d) {
    if (_dx > threshold) {
      HapticFeedback.mediumImpact();
      widget.onSwipeToVote();
    }
    _settle = Tween<double>(begin: _dx, end: 0).animate(
      CurvedAnimation(parent: _spring, curve: Curves.elasticOut),
    )..addListener(() => setState(() => _dx = _settle!.value));
    _spring.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final angle = (_dx / w).clamp(-1.0, 1.0) * 0.18;
    final ghosts = min(widget.behind, 2);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Fantômes des cartes suivantes : même stack visuelle que le web
        // (scale 0.93 / 0.86, décalage 14 / 26, rotation ±).
        for (var i = ghosts; i >= 1; i--)
          Transform.translate(
            offset: Offset(0, 14.0 * i),
            child: Transform.rotate(
              angle: i == 1 ? 0.04 : -0.03,
              child: Transform.scale(
                scale: 1 - 0.07 * i,
                child: _Face(gradient: widget.gradient, opacity: i == 1 ? 0.5 : 0.3, child: const SizedBox.expand()),
              ),
            ),
          ),
        GestureDetector(
          onHorizontalDragStart: (_) => _spring.stop(),
          onHorizontalDragUpdate: (d) => setState(() => _dx += d.delta.dx),
          onHorizontalDragEnd: _end,
          child: Transform.translate(
            offset: Offset(_dx, 0),
            child: Transform.rotate(
              angle: angle,
              child: _Face(
                gradient: widget.gradient,
                opacity: 1,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.categoryLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(widget.categoryLabel!.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                        ),
                      const Spacer(),
                      Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700,
                          height: 1.3, letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Row(
                        children: [
                          _RoundIcon(icon: Icons.favorite_border_rounded),
                          const SizedBox(width: 10),
                          const _RoundIcon(icon: Icons.ios_share_rounded),
                          const Spacer(),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 120),
                            opacity: 1 - (_dx / threshold).clamp(0, 1),
                            child: Text('${widget.intensityLabel} · swipe pour voter',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.child, required this.opacity, required this.gradient});
  final Widget child;
  final double opacity;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Color(0x50000000), blurRadius: 30, offset: Offset(0, 14))],
        ),
        child: child,
      ),
    );
  }
}
