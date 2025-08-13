import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/custom_repaint_boundary.dart';

class ColorPickerUtils {
  ColorPickerUtils({required this.boundaryKey});

  final GlobalKey boundaryKey;

  Future<Color?> getColor(
    RenderBox mouseRenderBox,
    Offset clickPosition,
  ) async {
    final backgroundBoundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderImageRepaintBoundary?;
    final matrix = mouseRenderBox.getTransformTo(backgroundBoundary);
    final transformedClickPosition = MatrixUtils.transformPoint(
      matrix,
      clickPosition,
    );
    if (backgroundBoundary == null) return null;

    final backgroundBoundaryBox = backgroundBoundary.paintBounds;

    final cursorRect = Rect.fromCenter(
      center: transformedClickPosition,
      width: 1,
      height: 1,
    );

    if (!backgroundBoundaryBox.contains(transformedClickPosition)) return null;

    // Pixel ratio requires to to be an odd number.
    // Otherwise further calculations won't succeed
    final image = await backgroundBoundary.toImage(
      rect: cursorRect,
      pixelRatio: 31,
    );

    final bytes = await image.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    );

    if (bytes == null) return null;

    final pixels = bytes.buffer.asUint32List();

    final pixel = pixels[pixels.length ~/ 2];
    final argbColor = _abgrToArgb(pixel);
    final color = Color(argbColor);
    return color;
  }
}

int _abgrToArgb(int argbColor) {
  final r = (argbColor >> 16) & 0xFF;
  final b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
