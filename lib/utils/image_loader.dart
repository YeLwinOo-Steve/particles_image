import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Future<ui.Image> loadAssetImage(String asset) {
  final completer = Completer<ui.Image>();
  final stream = AssetImage(asset).resolve(ImageConfiguration.empty);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    },
    onError: (e, _) {
      completer.completeError(e);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}

/// Redraw [src] fitted to [targetWidth], preserving aspect ratio.
Future<ui.Image> fitImage(ui.Image src, double targetWidth) async {
  if (src.width <= targetWidth) return src;
  final scale = targetWidth / src.width;
  final w = (src.width * scale).round();
  final h = (src.height * scale).round();

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawImageRect(
    src,
    Rect.fromLTWH(0, 0, src.width.toDouble(), src.height.toDouble()),
    Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
    Paint()..filterQuality = FilterQuality.high,
  );
  return recorder.endRecording().toImage(w, h);
}
