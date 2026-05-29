import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/settings.dart';

class SidePanel extends StatelessWidget {
  final Settings settings;
  const SidePanel({super.key, required this.settings});

  Settings get s => settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kPanelWidth,
      color: kPanelBg,
      child: ListenableBuilder(
        listenable: s,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _header('CONTROLS'),
            _divider(),
            _section('PARTICLES'),
            _slider('Dot Radius', s.dotRadius, 0.5, 6, (v) {
              s.dotRadius = v;
              s.change();
            }),
            _slider('Dot Spacing', s.gap.toDouble(), 1, 16, (v) {
              s.gap = v.round();
              s.resample();
            }),
            _divider(),
            _section('HOVER'),
            _slider('Radius', s.hoverRadius, 10, 150, (v) {
              s.hoverRadius = v;
              s.change();
            }),
            _slider('Force', s.hoverForce, 1, 20, (v) {
              s.hoverForce = v;
              s.change();
            }),
            _divider(),
            _section('PHYSICS'),
            _slider('Damping', s.damping, 0.5, 1, (v) {
              s.damping = v;
              s.change();
            }),
            _slider('Assembly Speed', s.assembleSpeed, 0.01, 0.3, (v) {
              s.assembleSpeed = v;
              s.change();
            }),
            _slider('Scatter', s.scatter, 0, 1.5, (v) {
              s.scatter = v;
              s.resample();
            }),
            _slider('Fade-in Step', s.fadeInStep, 0.005, 0.2, (v) {
              s.fadeInStep = v;
              s.change();
            }),
            _slider('Reveal / Frame', s.revealPerFrame.toDouble(), 5, 300, (v) {
              s.revealPerFrame = v.round();
              s.change();
            }),
            _divider(),
            _section('SAMPLING'),
            _slider('Image Size', s.imageSize, 80, 480, (v) {
              s.imageSize = v;
              s.resample();
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _header(String t) => Text(
    t,
    style: const TextStyle(
      color: Colors.white38,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 2,
    ),
  );

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(
      t,
      style: const TextStyle(
        color: Colors.white24,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    ),
  );

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
  );

  Widget _slider(
    String label,
    double value,
    double lo,
    double hi,
    ValueChanged<double> onChanged,
  ) {
    final display = value < 1
        ? value.toStringAsFixed(2)
        : value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            Text(
              display,
              style: const TextStyle(color: Colors.white30, fontSize: 11),
            ),
          ],
        ),
        SizedBox(
          height: 30,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: Colors.white24,
              inactiveTrackColor: Colors.white10,
              thumbColor: Colors.white54,
              overlayColor: Colors.white.withValues(alpha: 0.08),
            ),
            child: Slider(
              value: value.clamp(lo, hi),
              min: lo,
              max: hi,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
