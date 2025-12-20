import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        accumulator = widget.initial;
      },
      onPanUpdate: (details) {
        final sign = switch (widget.direction) {
          DraggableDividerDirection.startToEnd => 1,
          DraggableDividerDirection.endToStart => -1,
        };
        final axisDelta = switch (widget.axis) {
          Axis.horizontal => details.delta.dx,
          Axis.vertical => details.delta.dy,
        };
        accumulator += sign * axisDelta;
        widget.onUpdate?.call(accumulator);
      },
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
