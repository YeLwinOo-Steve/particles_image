import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final int revealed;
  final double dotRadius;

  ParticlePainter(this.particles, this.revealed, this.dotRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < math.min(revealed, particles.length); i++) {
      final p = particles[i];
      paint.color = p.color.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) => true;
}
