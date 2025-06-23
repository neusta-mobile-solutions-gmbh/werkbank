import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

extension OffsetExtension on Offset {
  Vector3 toVector3() {
    return Vector3(dx, dy, 0);
  }

  Vector2 toVector2() {
    return Vector2(dx, dy);
  }
}

extension Vector2Extension on Vector2 {
  Offset toOffset() {
    return Offset(x, y);
  }
}

extension RectExtension on Rect {
  double lengthAlong(Axis axis) {
    return switch (axis) {
      Axis.horizontal => width,
      Axis.vertical => height,
    };
  }
}

extension AxisExtension on Axis {
  Axis get perpendicular {
    return switch (this) {
      Axis.horizontal => Axis.vertical,
      Axis.vertical => Axis.horizontal,
    };
  }
}

({Line startLine, Line endLine}) rectToTransformedLines({
  required Rect rect,
  required Matrix4 transform,
  required Axis axis,
}) {
  var effectiveRect = rect;
  final extendDown = effectiveRect.height == 0;
  final extendRight = effectiveRect.width == 0;
  if (extendDown || extendRight) {
    effectiveRect = Rect.fromPoints(
      effectiveRect.topLeft,
      effectiveRect.bottomRight +
          Offset(
            extendRight ? 64 : 0,
            extendDown ? 64 : 0,
          ),
    );
  }

  final useCaseQuad = Quad.points(
    rect.topLeft.toVector3(),
    rect.topRight.toVector3(),
    rect.bottomLeft.toVector3(),
    rect.bottomRight.toVector3(),
  );
  transform
    ..perspectiveTransform(useCaseQuad.point0)
    ..perspectiveTransform(useCaseQuad.point1)
    ..perspectiveTransform(useCaseQuad.point2)
    ..perspectiveTransform(useCaseQuad.point3);

  final startLine = switch (axis) {
    // Left most
    Axis.vertical => Line.fromStartEnd(
      start: useCaseQuad.point0.xy,
      end: useCaseQuad.point2.xy,
    ),
    // Top most
    Axis.horizontal => Line.fromStartEnd(
      start: useCaseQuad.point0.xy,
      end: useCaseQuad.point1.xy,
    ),
  };
  final isEndInvalid = switch (axis) {
    Axis.horizontal => extendDown,
    Axis.vertical => extendRight,
  };
  if (isEndInvalid) {
    return (startLine: startLine, endLine: startLine);
  }
  final endLine = switch (axis) {
    // Right most
    Axis.vertical => Line.fromStartEnd(
      start: useCaseQuad.point1.xy,
      end: useCaseQuad.point3.xy,
    ),
    // Bottom most
    Axis.horizontal => Line.fromStartEnd(
      start: useCaseQuad.point2.xy,
      end: useCaseQuad.point3.xy,
    ),
  };

  return (startLine: startLine, endLine: endLine);
}

class Line {
  Line({required this.pivot, required this.direction});

  Line.fromStartEnd({
    required Vector2 start,
    required Vector2 end,
  }) : pivot = start,
       direction = end - start;

  final Vector2 pivot;
  final Vector2 direction;

  Vector2? intersection(Line other) {
    final a = direction;
    final b = other.direction;
    final c = other.pivot - pivot;

    final d = a.x * b.y - a.y * b.x;
    if (d == 0) {
      return null;
    }

    final t = (b.y * c.x - b.x * c.y) / d;
    return pivot + a * t;
  }

  @override
  String toString() {
    return 'Line(pivot: $pivot, direction: $direction)';
  }
}
