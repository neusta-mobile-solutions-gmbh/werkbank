import 'package:flutter/material.dart';

typedef SimpleOffsetCallback = void Function(Offset offset);

enum GestureAxis {
  horizontal,
  vertical,
  both,
}

class AxisDragGestureDetector extends StatelessWidget {
  const AxisDragGestureDetector({
    super.key,
    required this.axis,
    this.enabled = true,
    required this.onStartOffsetUpdate,
    required this.onOffsetUpdate,
    this.onEndOrCancel,
    this.onSecondaryTap,
    required this.child,
  });

  final GestureAxis axis;
  final bool enabled;
  final SimpleOffsetCallback onStartOffsetUpdate;
  final SimpleOffsetCallback onOffsetUpdate;
  final VoidCallback? onEndOrCancel;
  final GestureTapCallback? onSecondaryTap;
  final Widget child;

  Offset _clipOffset(Offset offset) => switch (axis) {
    GestureAxis.horizontal => Offset(offset.dx, 0),
    GestureAxis.vertical => Offset(0, offset.dy),
    GestureAxis.both => offset,
  };

  void _handleDown(DragDownDetails details) =>
      onStartOffsetUpdate(_clipOffset(details.localPosition));

  void _handleStart(DragStartDetails details) =>
      onStartOffsetUpdate(_clipOffset(details.localPosition));

  void _handleUpdate(DragUpdateDetails details) =>
      onOffsetUpdate(_clipOffset(details.localPosition));

  void _handleEnd(DragEndDetails details) => onEndOrCancel?.call();

  void _handleCancel() => onEndOrCancel?.call();

  @override
  Widget build(BuildContext context) {
    final onDown = enabled ? _handleDown : null;
    final onStart = enabled ? _handleStart : null;
    final onUpdate = enabled ? _handleUpdate : null;
    final onEnd = enabled ? _handleEnd : null;
    final onCancel = enabled ? _handleCancel : null;

    return MouseRegion(
      cursor: switch (axis) {
        _ when !enabled => MouseCursor.defer,
        GestureAxis.horizontal => SystemMouseCursors.resizeLeftRight,
        GestureAxis.vertical => SystemMouseCursors.resizeUpDown,
        GestureAxis.both => SystemMouseCursors.precise,
      },
      child: switch (axis) {
        GestureAxis.horizontal => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragDown: onDown,
          onHorizontalDragStart: onStart,
          onHorizontalDragUpdate: onUpdate,
          onHorizontalDragEnd: onEnd,
          onHorizontalDragCancel: onCancel,
          onSecondaryTap: enabled ? onSecondaryTap : null,
          child: child,
        ),
        GestureAxis.vertical => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragDown: onDown,
          onVerticalDragStart: onStart,
          onVerticalDragUpdate: onUpdate,
          onVerticalDragEnd: onEnd,
          onVerticalDragCancel: onCancel,
          onSecondaryTap: enabled ? onSecondaryTap : null,
          child: child,
        ),
        GestureAxis.both => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanDown: onDown,
          onPanStart: onStart,
          onPanUpdate: onUpdate,
          onPanEnd: onEnd,
          onPanCancel: onCancel,
          onSecondaryTap: enabled ? onSecondaryTap : null,
          child: child,
        ),
      },
    );
  }
}
