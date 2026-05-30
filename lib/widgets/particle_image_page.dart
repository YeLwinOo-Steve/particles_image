import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/settings.dart';
import 'icon_button.dart';
import 'particle_canvas.dart';
import 'side_panel.dart';
import 'thumbnail_row.dart';

class ParticleImagePage extends StatefulWidget {
  const ParticleImagePage({super.key});

  @override
  State<ParticleImagePage> createState() => _ParticleImagePageState();
}

class _ParticleImagePageState extends State<ParticleImagePage> {
  final _settings = Settings();
  final _canvasKey = GlobalKey<ParticleCanvasState>();
  bool _panelOpen = false;
  bool _panelDefaultSet = false;
  int _selected = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_panelDefaultSet) {
      _panelDefaultSet = true;
      _panelOpen = MediaQuery.sizeOf(context).width > kCompactBreakpoint;
    }
  }

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  void _togglePanel() => setState(() => _panelOpen = !_panelOpen);

  Widget _canvasStack({required bool compact}) {
    return Stack(
      children: [
        ParticleCanvas(
          key: _canvasKey,
          settings: _settings,
          asset: kSources[_selected].asset,
        ),
        Positioned(
          top: compact ? 8 : 12,
          left: compact ? 8 : 12,
          child: SafeArea(
            bottom: false,
            right: false,
            child: Row(
              children: [
                ParticleIconButton(
                  icon: _panelOpen ? Icons.chevron_left : Icons.chevron_right,
                  onTap: _togglePanel,
                ),
                const SizedBox(width: 6),
                ParticleIconButton(
                  icon: Icons.replay,
                  onTap: () => _canvasKey.currentState?.replay(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: compact ? 12 : 20,
          left: 0,
          right: 0,
          child: SafeArea(
            top: false,
            child: Center(
              child: ThumbnailRow(
                selected: _selected,
                onSelect: (i) => setState(() => _selected = i),
                compact: compact,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _wideLayout() {
    return Row(
      children: [
        ClipRect(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: _panelOpen ? kPanelWidth : 0,
            child: OverflowBox(
              minWidth: kPanelWidth,
              maxWidth: kPanelWidth,
              alignment: Alignment.centerLeft,
              child: SidePanel(settings: _settings),
            ),
          ),
        ),
        Expanded(child: _canvasStack(compact: false)),
      ],
    );
  }

  Widget _compactLayout(double height) {
    final panelHeight = math.min(height * 0.45, 360.0);

    return Column(
      children: [
        Expanded(child: _canvasStack(compact: true)),
        ClipRect(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: _panelOpen ? panelHeight : 0,
            child: OverflowBox(
              minHeight: panelHeight,
              maxHeight: panelHeight,
              alignment: Alignment.topCenter,
              child: SidePanel(settings: _settings),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth <= kCompactBreakpoint;
          if (compact) {
            return _compactLayout(constraints.maxHeight);
          }
          return _wideLayout();
        },
      ),
    );
  }
}
