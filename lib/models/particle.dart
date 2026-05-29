import 'package:flutter/material.dart';

class Particle {
  double x, y, vx = 0, vy = 0, opacity = 0;
  final double restX, restY;
  final Color color;
  Particle(this.x, this.y, this.restX, this.restY, this.color);
}
