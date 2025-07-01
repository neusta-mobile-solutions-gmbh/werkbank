import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

enum DraggableDividerDirection {
  startToEnd,
  endToStart,
}

typedef DraggableDividerCallback =
    void Function(
      double unboundedValue,
    );

class DraggableDivider extends StatefulWidget {
  const DraggableDivider({
    required this.onUpdate,
    required this.initial,
    this.axis = Axis.horizontal,
    this.direction = DraggableDividerDirection.startToEnd,
    super.key,
  });

  final DraggableDividerCallback? onUpdate;

  final double initial;

  final Axis axis;
  final DraggableDividerDirection direction;

  @override
  State<DraggableDivider> createState() => _DraggableDividerState();
}

class _DraggableDividerState extends State<DraggableDivider> {
  late double accumulator;

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
        final vorzeichen =
            widget.direction == DraggableDividerDirection.startToEnd ? 1 : -1;
        switch (widget.axis) {
          case Axis.horizontal:
            final dx = vorzeichen * details.delta.dx;
            final newValue = dx + accumulator;
            accumulator += dx;
            widget.onUpdate?.call(newValue);
          case Axis.vertical:
            final dy = vorzeichen * details.delta.dy;
            final newValue = dy + accumulator;
            accumulator += dy;
            widget.onUpdate?.call(newValue);
        }
      },
      onPanEnd: (details) {
        resetGestureDetector();
      },
      onPanCancel: resetGestureDetector,
      child: MouseRegion(
        cursor: widget.axis == Axis.horizontal
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.resizeRow,
        /* TODO(lzuttermeister): These dividers should not be thicker visually.
             This is just temporary so that the drag area is large enough. */
        child: switch (widget.axis) {
          Axis.horizontal => const WDivider.vertical(thickness: 4),
          Axis.vertical => const WDivider.horizontal(thickness: 4),
        },
      ),
    );
  }
}
