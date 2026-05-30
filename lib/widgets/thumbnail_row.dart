import 'package:flutter/material.dart';

import '../constants.dart';

class ThumbnailRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  final bool compact;

  const ThumbnailRow({
    super.key,
    required this.selected,
    required this.onSelect,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 56.0 : 80.0;
    final padding = compact ? 10.0 : 18.0;
    final margin = compact ? 4.0 : 6.0;
    final radius = compact ? 12.0 : 16.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < kSources.length; i++)
            GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                width: size,
                height: size,
                margin: EdgeInsets.symmetric(horizontal: margin),
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: selected == i ? Colors.white70 : Colors.white12,
                    width: selected == i ? 2 : 1,
                  ),
                ),
                child: Image.asset(
                  kSources[i].asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      kSources[i].label.substring(0, 1),
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: compact ? 12 : 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
