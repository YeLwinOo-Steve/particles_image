import 'package:flutter/material.dart';

import '../constants.dart';

class ThumbnailRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;

  const ThumbnailRow({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < kSources.length; i++)
          GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
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
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
