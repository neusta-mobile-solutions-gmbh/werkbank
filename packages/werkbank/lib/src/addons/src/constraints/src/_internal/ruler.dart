import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:werkbank/werkbank.dart';

class Ruler extends StatelessWidget {
  const Ruler({
    required this.constraints,
    required this.axis,
    required this.notifier,
    super.key,
  });

  final BoxConstraints constraints;
  final Axis axis;
  final ValueNotifier<LayoutInfo?> notifier;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return CustomPaint(
      painter: _RulerPainter(
        constraints: constraints,
        notifier: notifier,
        axis: axis,
        tickMarkerTextStyle: context.werkbankTextTheme.textLight,
        surfaceColor: colorScheme.surface,
        minConstraintsHighlightColor: colorScheme.text,
        maxConstraintsHighlightColor: colorScheme.fieldContent,
        onSurfaceMarkingColor: colorScheme.textLight,
        onHighlightMarkingColor: colorScheme.textActive,
        dividerColor: colorScheme.divider,
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.constraints,
    required this.notifier,
    required this.axis,
    required this.tickMarkerTextStyle,
    required this.surfaceColor,
    required this.minConstraintsHighlightColor,
    required this.maxConstraintsHighlightColor,
    required this.onSurfaceMarkingColor,
    required this.onHighlightMarkingColor,
    required this.dividerColor,
  }) : super(repaint: notifier);

  final BoxConstraints constraints;
  final ValueNotifier<LayoutInfo?> notifier;
  final Axis axis;

  final TextStyle tickMarkerTextStyle;
  final Color surfaceColor;
  final Color minConstraintsHighlightColor;
  final Color maxConstraintsHighlightColor;
  final Color onSurfaceMarkingColor;
  final Color onHighlightMarkingColor;
  final Color dividerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas
      ..clipRect(Offset.zero & size)
      ..drawRect(rect, Paint()..color = surfaceColor);
    _paintContent(canvas, size);
    canvas.drawRect(
      switch (axis) {
        Axis.horizontal => Rect.fromLTWH(0, size.height - 1, size.width, 1),
        Axis.vertical => Rect.fromLTWH(size.width - 1, 0, 1, size.height),
      },
      Paint()..color = dividerColor,
    );
  }

  void _paintContent(Canvas canvas, Size size) {
    final transform = notifier.value?.transform;
    final useCaseSize = notifier.value?.size;
    if (transform == null || useCaseSize == null) {
      return;
    }

    final inverseTransform = Matrix4.tryInvert(
      PointerEvent.removePerspectiveTransform(transform),
    );
    if (inverseTransform == null) {
      return;
    }

    final double extent;
    final double thickness;
    final double useCaseExtent;
    final double minConstraintsExtent;
    final double maxConstraintsExtent;
    final Offset Function(double pos) posToMarkPoint;
    switch (axis) {
      case Axis.horizontal:
        extent = size.width;
        thickness = size.height;
        useCaseExtent = useCaseSize.width;
        minConstraintsExtent = constraints.minWidth;
        maxConstraintsExtent = constraints.maxWidth;
        posToMarkPoint = (pos) => MatrixUtils.transformPoint(
          inverseTransform,
          Offset(pos, 0),
        );
      case Axis.vertical:
        extent = size.height;
        thickness = size.width;
        useCaseExtent = useCaseSize.height;
        minConstraintsExtent = constraints.minHeight;
        maxConstraintsExtent = constraints.maxHeight;
        posToMarkPoint = (pos) {
          return MatrixUtils.transformPoint(
            inverseTransform,
            Offset(0, extent - pos),
          );
        };
    }

    final startPoint = posToMarkPoint(0);
    final endPoint = posToMarkPoint(extent);
    final double start;
    final double end;
    switch (axis) {
      case Axis.horizontal:
        start = startPoint.dx;
        end = endPoint.dx;
      case Axis.vertical:
        start = startPoint.dy;
        end = endPoint.dy;
    }
    if (start == end) {
      return;
    }
    Offset markToPosPoint(double mark) => MatrixUtils.transformPoint(
      transform,
      Offset.lerp(
        startPoint,
        endPoint,
        _mapToZeroOneRange(
          value: mark,
          fromMin: start,
          fromMax: end,
        ),
      )!,
    );

    final markToPos = switch (axis) {
      Axis.horizontal => (double mark) => markToPosPoint(mark).dx,
      Axis.vertical => (double mark) => extent - markToPosPoint(mark).dy,
    };

    void callPaintRuler() {
      _paintRuler(
        canvas: canvas,
        extent: extent,
        thickness: thickness,
        start: start,
        end: end,
        useCaseExtent: useCaseExtent,
        minConstraintsExtent: minConstraintsExtent,
        maxConstraintsExtent: maxConstraintsExtent,
        markToPos: markToPos,
      );
    }

    switch (axis) {
      case Axis.horizontal:
        callPaintRuler();
      case Axis.vertical:
        canvas.save();
        canvas.rotate(radians(-90));
        canvas.translate(-size.height, 0);
        callPaintRuler();
        canvas.restore();
    }
  }

  void _paintRuler({
    required Canvas canvas,
    required double extent,
    required double thickness,
    required double start,
    required double end,
    required double useCaseExtent,
    required double minConstraintsExtent,
    required double maxConstraintsExtent,
    required double Function(double mark) markToPos,
  }) {
    _paintRulerMarkings(
      canvas: canvas,
      extent: extent,
      thickness: thickness,
      color: onSurfaceMarkingColor,
      start: start,
      end: end,
      useCaseExtent: useCaseExtent,
      markToPos: markToPos,
    );

    final center = useCaseExtent / 2;
    Rect? createRect(
      double constraintsExtent, {
      bool drawInfinite = false,
    }) {
      if ((!drawInfinite && constraintsExtent.isInfinite) ||
          constraintsExtent == 0) {
        return null;
      }
      if (constraintsExtent.isInfinite) {
        return Rect.fromLTWH(0, 0, extent, thickness);
      }
      final left = markToPos(
        center - constraintsExtent / 2,
      ).clamp(0, extent).toDouble();
      final right = markToPos(
        center + constraintsExtent / 2,
      ).clamp(0, extent).toDouble();
      return Rect.fromLTRB(left, 0, right, thickness);
    }

    var maxRect = createRect(maxConstraintsExtent);
    final minRect = createRect(minConstraintsExtent, drawInfinite: true);
    // If the min constraints are set, but the max constraints are infinite,
    // we need to draw the max rect over the whole area.
    // Otherwise it is not visually distinguishable from min and max being
    // finite and equal.
    if (minRect != null) {
      maxRect ??= Rect.fromLTWH(0, 0, extent, thickness);
    }
    if (maxRect != null) {
      canvas.drawRect(maxRect, Paint()..color = maxConstraintsHighlightColor);
    }
    if (minRect != null) {
      final dividerPaint = Paint()..color = surfaceColor;
      canvas
        ..drawRect(minRect, Paint()..color = minConstraintsHighlightColor)
        ..drawLine(
          Offset(minRect.left, 0),
          Offset(minRect.left, thickness),
          dividerPaint,
        )
        ..drawLine(
          Offset(minRect.right, 0),
          Offset(minRect.right, thickness),
          dividerPaint,
        );
    }
    final clipRect = maxRect ?? minRect;
    if (clipRect != null) {
      canvas
        ..save()
        ..clipRect(clipRect);
      _paintRulerMarkings(
        canvas: canvas,
        extent: extent,
        thickness: thickness,
        color: onHighlightMarkingColor,
        start: start,
        end: end,
        useCaseExtent: useCaseExtent,
        markToPos: markToPos,
      );
      canvas.restore();
    }
  }

  void _paintRulerMarkings({
    required Canvas canvas,
    required double extent,
    required double thickness,
    required Color color,
    required double start,
    required double end,
    required double useCaseExtent,
    required double Function(double mark) markToPos,
  }) {
    final tickPaint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final textStyle = tickMarkerTextStyle.apply(color: color);

    /* TODO(lzuttermeister): This assumes event spacing of the ticks along the
         ruler, which may not be the case for perspective transforms.
         However if the ticks get to close, we skip them in the loop below. */
    const minTickDistance = 36.0;
    final minTickDivision = (end - start).abs() / extent * minTickDistance;

    // If the computation of minTickDivision is not finite,
    // _computeTickDivision may run into an infinite loop.
    if (!minTickDivision.isFinite) {
      return;
    }
    final tickDivision = _computeTickDivision(minTickDivision);

    final minTick = (min(start, end) / tickDivision).floor() * tickDivision;
    final maxTick = (max(start, end) / tickDivision).ceil() * tickDivision;

    final useCaseExtentPos = markToPos(useCaseExtent);
    canvas.drawLine(
      Offset(useCaseExtentPos, 0),
      Offset(useCaseExtentPos, thickness),
      tickPaint,
    );

    double? prevTickPosition;
    for (var tick = minTick; tick <= maxTick; tick += tickDivision) {
      final tickPosition = markToPos(tick.toDouble());
      if (prevTickPosition != null &&
          (tickPosition - prevTickPosition).abs() < minTickDistance) {
        continue;
      }
      prevTickPosition = tickPosition;
      canvas.drawLine(
        Offset(tickPosition, thickness - 4),
        Offset(tickPosition, thickness - 1),
        tickPaint,
      );
      final textSpan = TextSpan(
        text: tick.toString(),
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: minTickDistance);
      final xCenter = tickPosition - textPainter.width / 2;
      final yCenter = (thickness - textPainter.height) / 2;
      final offset = Offset(xCenter, yCenter);
      textPainter.paint(canvas, offset);
    }
  }

  static int _computeTickDivision(double minTickDivision) {
    if (minTickDivision <= 1) {
      return 1;
    }
    if (minTickDivision <= 2) {
      return 2;
    }
    var fives = 5;
    var tens = 10;
    while (true) {
      if (minTickDivision <= fives) {
        return fives;
      }
      if (minTickDivision <= tens) {
        return tens;
      }
      fives *= 10;
      tens *= 10;
    }
  }

  static double _mapToZeroOneRange({
    required double value,
    required double fromMin,
    required double fromMax,
    bool clamp = false,
  }) {
    final result = (value - fromMin) / (fromMax - fromMin);
    return clamp ? result.clamp(0, 1) : result;
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    return constraints != oldDelegate.constraints ||
        notifier != oldDelegate.notifier ||
        axis != oldDelegate.axis ||
        tickMarkerTextStyle != oldDelegate.tickMarkerTextStyle ||
        surfaceColor != oldDelegate.surfaceColor ||
        minConstraintsHighlightColor !=
            oldDelegate.minConstraintsHighlightColor ||
        maxConstraintsHighlightColor !=
            oldDelegate.maxConstraintsHighlightColor ||
        onSurfaceMarkingColor != oldDelegate.onSurfaceMarkingColor ||
        onHighlightMarkingColor != oldDelegate.onHighlightMarkingColor ||
        dividerColor != oldDelegate.dividerColor;
  }
}
