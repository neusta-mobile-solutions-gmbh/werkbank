import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

@immutable
class ViewTransform {
  const ViewTransform({
    required this.offset,
    required this.scale,
  });

  static ViewTransform identity = const ViewTransform(
    offset: Offset.zero,
    scale: 1,
  );

  final Offset offset;
  final double scale;

  ViewTransform translated(Offset offset) {
    return ViewTransform(
      offset: this.offset + offset,
      scale: scale,
    );
  }

  ViewTransform scaled({
    required double scale,
    required Offset focalPoint,
    required double minScale,
    required double maxScale,
  }) {
    final newScale = (this.scale * scale).clamp(minScale, maxScale);
    return ViewTransform(
      offset: (offset - focalPoint) * newScale / this.scale + focalPoint,
      scale: newScale,
    );
  }

  Matrix4 toMatrix() {
    return Matrix4.identity()
      ..translateByVector3(Vector3(offset.dx, offset.dy, 0))
      ..scaleByDouble(scale, scale, 1, 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewTransform &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          scale == other.scale;

  @override
  int get hashCode => Object.hash(offset, scale);
}
