import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/particle.dart';
import '../models/settings.dart';
import 'image_loader.dart';

/// Load a bundled PNG, scale it, and sample opaque pixels into particles.
Future<List<Particle>> rasterize(
  String asset,
  Size canvas,
  Settings s,
  math.Random rng,
) async {
  final raw = await loadAssetImage(asset);
  final image = await fitImage(raw, s.imageSize);

  final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (bytes == null) return [];
  final pixels = bytes.buffer.asUint8List();
  final w = image.width, h = image.height;

  final originX = (canvas.width - w) / 2;
  final originY = (canvas.height - h) / 2;
  final step = s.gap.clamp(1, 999);

  final particles = <Particle>[];
  for (int py = 0; py < h; py += step) {
    for (int px = 0; px < w; px += step) {
      final i = (py * w + px) * 4;
      if (pixels[i + 3] / 255.0 < 0.4) continue;

      final restX = originX + px;
      final restY = originY + py;
      final startX =
          restX + (rng.nextDouble() - 0.5) * canvas.width * s.scatter;
      final startY =
          restY + (rng.nextDouble() - 0.5) * canvas.height * s.scatter;
      final color = Color.fromARGB(
        255,
        pixels[i],
        pixels[i + 1],
        pixels[i + 2],
      );

      particles.add(Particle(startX, startY, restX, restY, color));
    }
  }
  return particles;
}
