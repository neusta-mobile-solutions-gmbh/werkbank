import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomRepaintBoundary extends SingleChildRenderObjectWidget {
  const CustomRepaintBoundary({super.key, super.child});

  @override
  RenderRepaintBoundary createRenderObject(BuildContext context) =>
      RenderImageRepaintBoundary();
}

class RenderImageRepaintBoundary extends RenderRepaintBoundary {
  @override
  Future<ui.Image> toImage({Rect? rect, double pixelRatio = 1.0}) {
    assert(
      !debugNeedsPaint,
      'To use [toImage], the render object must have gone through the paint '
      'phase [debugNeedsPaint] must be false).',
    );
    if (rect == null) {
      return super.toImage(pixelRatio: pixelRatio);
    }
    final offsetLayer = layer! as OffsetLayer;
    return offsetLayer.toImage(rect, pixelRatio: pixelRatio);
  }
}
