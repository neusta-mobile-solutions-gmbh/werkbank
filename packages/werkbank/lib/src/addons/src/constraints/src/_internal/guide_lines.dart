import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/math.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/ruler_overlay.dart';
import 'package:werkbank/werkbank.dart';

class GuideLines extends StatelessWidget {
  const GuideLines({
    required this.constraints,
    required this.notifier,
    required this.constraintsMode,
    required this.currentlyChangingConstraints,
    required this.child,
    super.key,
  });

  final BoxConstraints constraints;
  final ValueNotifier<LayoutInfo?> notifier;
  final ConstraintsMode constraintsMode;
  final bool currentlyChangingConstraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return CustomPaint(
      foregroundPainter: _GuideLinesPainter(
        constraints: constraints,
        notifier: notifier,
        constraintsMode: constraintsMode,
        currentlyChangingConstraints: currentlyChangingConstraints,
        // TODO(lzuttermeister): Replace with design color?
        hightlightColor: Colors.red.shade600,
        /* TODO(lzuttermeister): Ask design how to paint this.
             Don't use opacity? */
        minColor: colorScheme.text.withValues(alpha: 0.5),
        sizeColor: colorScheme.hoverFocus.withValues(alpha: 0.5),
        maxColor: colorScheme.fieldContent.withValues(alpha: 0.5),
      ),
      child: child,
    );
  }
}

class _GuideLinesPainter extends CustomPainter {
  _GuideLinesPainter({
    required this.constraints,
    required this.notifier,
    required this.constraintsMode,
    required this.currentlyChangingConstraints,
    required this.hightlightColor,
    required this.minColor,
    required this.sizeColor,
    required this.maxColor,
  }) : super(repaint: notifier);

  final BoxConstraints constraints;
  final ValueNotifier<LayoutInfo?> notifier;

  final ConstraintsMode constraintsMode;
  final bool currentlyChangingConstraints;

  final Color hightlightColor;
  final Color minColor;
  final Color sizeColor;
  final Color maxColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.shortestSide == 0) {
      return;
    }
    final paintGuideLines =
        constraintsMode.supportsBothAxes || currentlyChangingConstraints;
    if (!paintGuideLines) return;
    final borderRect = Offset.zero & size;
    canvas.clipRect(borderRect);

    final transform = notifier.value?.transform;
    final useCaseSize = notifier.value?.size;
    if (transform == null || useCaseSize == null) {
      return;
    }

    final useCaseSizeRect = Offset.zero & useCaseSize;

    final Rect? minConstraintRectVertical;
    final Rect? minConstraintRectHorizontal;
    if (constraints.minWidth.isFinite) {
      minConstraintRectVertical = Rect.fromCenter(
        center: useCaseSizeRect.center,
        width: constraints.minWidth,
        height: useCaseSizeRect.height,
      );
    } else {
      minConstraintRectVertical = null;
    }
    if (constraints.minHeight.isFinite) {
      minConstraintRectHorizontal = Rect.fromCenter(
        center: useCaseSizeRect.center,
        width: useCaseSizeRect.width,
        height: constraints.minHeight,
      );
    } else {
      minConstraintRectHorizontal = null;
    }

    final Rect? maxConstraintRectVertical;
    final Rect? maxConstraintRectHorizontal;
    if (constraints.maxWidth.isFinite) {
      maxConstraintRectVertical = Rect.fromCenter(
        center: useCaseSizeRect.center,
        width: constraints.maxWidth,
        height: useCaseSizeRect.height,
      );
    } else {
      maxConstraintRectVertical = null;
    }
    if (constraints.maxHeight.isFinite) {
      maxConstraintRectHorizontal = Rect.fromCenter(
        center: useCaseSizeRect.center,
        width: useCaseSizeRect.width,
        height: constraints.maxHeight,
      );
    } else {
      maxConstraintRectHorizontal = null;
    }

    final sizePaint = Paint()
      ..color = sizeColor
      ..strokeWidth = 1;
    _paintRectLines(
      canvas: canvas,
      size: size,
      rect: useCaseSizeRect,
      transform: transform,
      paint: sizePaint,
    );
    final highlightPaint = Paint()
      ..color = hightlightColor
      ..strokeWidth = 2;
    void paintMinRectLines() {
      final minConstraintsPaint = constraintsMode.modeSizesMin
          ? highlightPaint
          : (Paint()
              ..color = minColor
              ..strokeWidth = 1);
      if (minConstraintRectVertical != null &&
          minConstraintRectVertical.width > 0) {
        _paintRectSideLines(
          canvas: canvas,
          size: size,
          rect: minConstraintRectVertical,
          transform: transform,
          axis: Axis.vertical,
          paint: minConstraintsPaint,
        );
      }

      if (minConstraintRectHorizontal != null &&
          minConstraintRectHorizontal.height > 0) {
        _paintRectSideLines(
          canvas: canvas,
          size: size,
          rect: minConstraintRectHorizontal,
          transform: transform,
          axis: Axis.horizontal,
          paint: minConstraintsPaint,
        );
      }
    }

    void paintMaxRectLines() {
      final maxConstraintsPaint = constraintsMode.modeSizesMax
          ? highlightPaint
          : (Paint()
              ..color = maxColor
              ..strokeWidth = 1);

      if (maxConstraintRectVertical != null &&
          maxConstraintRectVertical.width > 0) {
        _paintRectSideLines(
          canvas: canvas,
          size: size,
          rect: maxConstraintRectVertical,
          transform: transform,
          axis: Axis.vertical,
          paint: maxConstraintsPaint,
        );
      }

      if (maxConstraintRectHorizontal != null &&
          maxConstraintRectHorizontal.height > 0) {
        _paintRectSideLines(
          canvas: canvas,
          size: size,
          rect: maxConstraintRectHorizontal,
          transform: transform,
          axis: Axis.horizontal,
          paint: maxConstraintsPaint,
        );
      }
    }

    // We do this so that the highlighted lines are drawn on top.
    if (constraintsMode.modeSizesMax) {
      paintMinRectLines();
      paintMaxRectLines();
    } else {
      paintMaxRectLines();
      paintMinRectLines();
    }
  }

  void _paintRectLines({
    required Canvas canvas,
    required Size size,
    required Rect rect,
    required Matrix4 transform,
    required Paint paint,
  }) {
    for (final axis in Axis.values) {
      _paintRectSideLines(
        canvas: canvas,
        size: size,
        rect: rect,
        transform: transform,
        axis: axis,
        paint: paint,
      );
    }
  }

  void _paintRectSideLines({
    required Canvas canvas,
    required Size size,
    required Rect rect,
    required Matrix4 transform,
    required Axis axis,
    required Paint paint,
  }) {
    final borderRect = Offset.zero & size;
    late final topBorder = Line.fromStartEnd(
      start: borderRect.topLeft.toVector2(),
      end: borderRect.topRight.toVector2(),
    );
    late final bottomBorder = Line.fromStartEnd(
      start: borderRect.bottomLeft.toVector2(),
      end: borderRect.bottomRight.toVector2(),
    );
    late final leftBorder = Line.fromStartEnd(
      start: borderRect.topLeft.toVector2(),
      end: borderRect.bottomLeft.toVector2(),
    );
    late final rightBorder = Line.fromStartEnd(
      start: borderRect.topRight.toVector2(),
      end: borderRect.bottomRight.toVector2(),
    );
    final startBorderLine = switch (axis) {
      Axis.horizontal => leftBorder,
      Axis.vertical => topBorder,
    };
    final endBorderLine = switch (axis) {
      Axis.horizontal => rightBorder,
      Axis.vertical => bottomBorder,
    };
    final (
      startLine: horizontalStartLine,
      endLine: horizontalEndLine,
    ) = rectToTransformedLines(
      rect: rect,
      transform: transform,
      axis: axis,
    );
    Line? makeLine(Line line) {
      final startIntersection = line.intersection(startBorderLine);
      final endIntersection = line.intersection(endBorderLine);
      if (startIntersection == null || endIntersection == null) {
        return null;
      }
      return Line.fromStartEnd(
        start: startIntersection,
        end: endIntersection,
      );
    }

    final startLine = makeLine(horizontalStartLine);
    final endLine = makeLine(horizontalEndLine);
    void drawLine(Line? line) {
      if (line != null) {
        canvas.drawLine(
          line.pivot.toOffset(),
          (line.pivot + line.direction).toOffset(),
          paint,
        );
      }
    }

    if (startLine != null) {
      drawLine(startLine);
    }
    if (rect.lengthAlong(axis.perpendicular) == 0) {
      return;
    }
    if (endLine != null) {
      drawLine(endLine);
    }
  }

  @override
  bool shouldRepaint(covariant _GuideLinesPainter oldDelegate) {
    return constraints != oldDelegate.constraints ||
        notifier != oldDelegate.notifier ||
        constraintsMode != oldDelegate.constraintsMode ||
        currentlyChangingConstraints !=
            oldDelegate.currentlyChangingConstraints ||
        hightlightColor != oldDelegate.hightlightColor ||
        minColor != oldDelegate.minColor ||
        sizeColor != oldDelegate.sizeColor ||
        maxColor != oldDelegate.maxColor;
  }
}
