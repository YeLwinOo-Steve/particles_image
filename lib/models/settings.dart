import 'package:flutter/foundation.dart';

/// Particle simulation settings. Sampling fields trigger re-rasterization.
class Settings extends ChangeNotifier {
  // Live (read every frame)
  double dotRadius = 1.6;
  double hoverRadius = 80;
  double hoverForce = 6;
  double damping = 0.86;
  double assembleSpeed = 0.06;
  double fadeInStep = 0.04;
  int revealPerFrame = 40;

  // Sampling (re-rasterize on change)
  int gap = 4;
  double scatter = 0.7;
  double imageSize = 200;

  void change() => notifyListeners();
  void resample() => notifyListeners();
}
