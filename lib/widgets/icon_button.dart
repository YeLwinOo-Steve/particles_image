import 'package:flutter/material.dart';

class ParticleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ParticleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.white54),
      ),
    );
  }
}
