import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/particle.dart';
import '../models/settings.dart';
import '../utils/rasterize.dart';
import 'particle_painter.dart';

class ParticleCanvas extends StatefulWidget {
  final Settings settings;
  final String asset;

  const ParticleCanvas({
    super.key,
    required this.settings,
    required this.asset,
  });

  @override
  State<ParticleCanvas> createState() => ParticleCanvasState();
}

class ParticleCanvasState extends State<ParticleCanvas>
    with SingleTickerProviderStateMixin {
  final _rng = math.Random(7);
  List<Particle> _particles = [];
  Offset? _pointer;
  Size _canvas = Size.zero;
  int _revealed = 0;
  bool _building = false;
  String? _error;
  late final Ticker _ticker;

  Settings get s => widget.settings;

  @override
  void initState() {
    super.initState();
    s.addListener(_build);
    _ticker = createTicker(_step)..start();
  }

  @override
  void didUpdateWidget(ParticleCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) _build();
  }

  @override
  void dispose() {
    s.removeListener(_build);
    _ticker.dispose();
    super.dispose();
  }

  Future<void> _build() async {
    if (_canvas.isEmpty || _building) return;
    _building = true;
    try {
      final particles = await rasterize(widget.asset, _canvas, s, _rng);
      if (mounted) {
        setState(() {
          _particles = particles;
          _revealed = 0;
          _error = particles.isEmpty ? 'No opaque pixels sampled.' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _particles = [];
          _error = 'Could not load image asset.';
        });
      }
    }
    _building = false;
  }

  void replay() {
    for (final p in _particles) {
      p.x = p.restX + (_rng.nextDouble() - 0.5) * _canvas.width * s.scatter;
      p.y = p.restY + (_rng.nextDouble() - 0.5) * _canvas.height * s.scatter;
      p.vx = p.vy = 0;
      p.opacity = 0;
    }
    setState(() => _revealed = 0);
  }

  void _step(Duration _) {
    if (_particles.isEmpty) return;

    if (_revealed < _particles.length) {
      _revealed = math.min(_particles.length, _revealed + s.revealPerFrame);
    }

    for (int i = 0; i < _revealed; i++) {
      final p = _particles[i];

      final pointer = _pointer;
      if (pointer != null) {
        final dx = p.x - pointer.dx, dy = p.y - pointer.dy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist < s.hoverRadius && dist > 0.0001) {
          final strength = (1 - dist / s.hoverRadius) * s.hoverForce;
          p.vx += dx / dist * strength;
          p.vy += dy / dist * strength;
        }
      }

      p.x += p.vx;
      p.y += p.vy;
      p.vx *= s.damping;
      p.vy *= s.damping;
      p.x += (p.restX - p.x) * s.assembleSpeed;
      p.y += (p.restY - p.y) * s.assembleSpeed;
      if (p.opacity < 1) p.opacity = math.min(1, p.opacity + s.fadeInStep);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size != _canvas) {
          _canvas = size;
          WidgetsBinding.instance.addPostFrameCallback((_) => _build());
        }
        return MouseRegion(
          onHover: (e) => _pointer = e.localPosition,
          onExit: (_) => _pointer = null,
          child: GestureDetector(
            onPanUpdate: (e) => _pointer = e.localPosition,
            onPanEnd: (_) => _pointer = null,
            child: Stack(
              children: [
                CustomPaint(
                  size: size,
                  painter: ParticlePainter(_particles, _revealed, s.dotRadius),
                  child: const SizedBox.expand(),
                ),
                if (_error != null)
                  Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.white38),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
