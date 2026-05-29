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
  bool _panelOpen = true;
  int _selected = 0;

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Row(
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
          Expanded(
            child: Stack(
              children: [
                ParticleCanvas(
                  key: _canvasKey,
                  settings: _settings,
                  asset: kSources[_selected].asset,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      ParticleIconButton(
                        icon: _panelOpen
                            ? Icons.chevron_left
                            : Icons.chevron_right,
                        onTap: () => setState(() => _panelOpen = !_panelOpen),
                      ),
                      const SizedBox(width: 6),
                      ParticleIconButton(
                        icon: Icons.replay,
                        onTap: () => _canvasKey.currentState?.replay(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ThumbnailRow(
                      selected: _selected,
                      onSelect: (i) => setState(() => _selected = i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
