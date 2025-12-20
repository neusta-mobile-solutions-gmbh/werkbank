import 'package:flutter/material.dart';

typedef DraggableRegionCallback =
    void Function(
      Offset unboundedValue,
    );

class DraggableRegion extends StatefulWidget {
  const DraggableRegion({
    required this.onUpdate,
    required this.initial,
    required this.accelerationAndDirection,
    required this.child,
    super.key,
  });

  final DraggableRegionCallback? onUpdate;

  final Offset initial;

  final Offset accelerationAndDirection;

  final Widget child;

  @override
  State<DraggableRegion> createState() => _DraggableRegionState();
}

class _DraggableRegionState extends State<DraggableRegion> {
  late Offset accumulator;

  void resetGestureDetector() {
    // setState is needed to reset some inner Behavior
    // of the GestureDetector.
    // Otherwise, on the nect onPanDown + onPanUpdate
    // the dx and dy can be larger than expected
    // due to the old position of the GestureDetector.

    setState(() {
      accumulator = widget.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        accumulator = widget.initial;
      },
      onPanUpdate: (details) {
        final dx = widget.accelerationAndDirection.dx * details.delta.dx;
        final dy = widget.accelerationAndDirection.dy * details.delta.dy;
        final d = Offset(dx, dy);
        final newValue = accumulator + d;
        accumulator += d;
        widget.onUpdate?.call(newValue);
      },
      onPanEnd: (details) {
        resetGestureDetector();
      },
      onPanCancel: resetGestureDetector,
      child: MouseRegion(
        cursor: widget.accelerationAndDirection.dx == 0
            ? SystemMouseCursors.resizeUpDown
            : widget.accelerationAndDirection.dy == 0
            ? SystemMouseCursors.resizeLeftRight
            // Apparently, macos does not include a resizeUpLeftDownRight
            // cursor. Using precise as a fallback.
            : SystemMouseCursors.precise,
        /* TODO(lzuttermeister): These dividers should not be thicker visually.
             This is just temporary so that the drag area is large enough. */
        child: widget.child,
      ),
    );
  }
}
