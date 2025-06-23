import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/draggable_region.dart';

sealed class BorderBehavior {
  const BorderBehavior({
    required this.thickness,
  });

  final double thickness;
}

class NoneDraggableBorders extends BorderBehavior {
  const NoneDraggableBorders({
    super.thickness = 0.0,
  });
}

class DraggableBorders extends BorderBehavior {
  const DraggableBorders({
    required this.initialMaxValue,
    this.enableStartBorder = false,
    this.enableEndBorder = false,
    this.minDraggableValue,
    super.thickness = 8.0,
    this.needsDoubleAcceleration = false,
  }) : assert(
         minDraggableValue == null || minDraggableValue < initialMaxValue,
         'minDraggableValue must be smaller than initialMaxValue',
       );

  final double initialMaxValue;
  final bool enableStartBorder;
  final bool enableEndBorder;
  final double? minDraggableValue;

  // For example, if WDraggableConstrainedBox
  // is placed inside a Center widget, the expected
  // behavior during dragging would be that
  // the drag distance is added to the constraints
  // twice, making it larger on both the left and right sides.
  // However, if WDraggableConstrainedBox has a fixed
  // position, adding the drag distance only once
  // will appear correct.
  final bool needsDoubleAcceleration;
}

class WDraggableConstrainedBox extends StatefulWidget {
  const WDraggableConstrainedBox({
    this.leftRight = const NoneDraggableBorders(),
    this.topBottom = const NoneDraggableBorders(),
    required this.child,
    super.key,
  });

  final BorderBehavior leftRight;
  final BorderBehavior topBottom;
  final Widget child;

  @override
  State<WDraggableConstrainedBox> createState() =>
      _SDraggableConstrainedBoxState();
}

class _SDraggableConstrainedBoxState extends State<WDraggableConstrainedBox> {
  late double maxWidth;
  late double maxHeight;

  @override
  void initState() {
    super.initState();
    maxWidth = switch (widget.leftRight) {
      DraggableBorders(:final initialMaxValue) => initialMaxValue,
      NoneDraggableBorders() => double.infinity,
    };
    maxHeight = switch (widget.topBottom) {
      DraggableBorders(:final initialMaxValue) => initialMaxValue,
      NoneDraggableBorders() => double.infinity,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ourConstraints = BoxConstraints(
      maxWidth: maxWidth,
      minWidth: switch (widget.leftRight) {
        DraggableBorders() => maxWidth,
        NoneDraggableBorders() => 0.0,
      },
      maxHeight: maxHeight,
      minHeight: switch (widget.topBottom) {
        DraggableBorders() => maxHeight,
        NoneDraggableBorders() => 0.0,
      },
    );

    final topBottomMinDraggableValue = switch (widget.topBottom) {
      DraggableBorders(:final minDraggableValue) => minDraggableValue,
      NoneDraggableBorders() => null,
    };

    final leftRightMinDraggableValue = switch (widget.leftRight) {
      DraggableBorders(:final minDraggableValue) => minDraggableValue,
      NoneDraggableBorders() => null,
    };

    final leftRightAcceleration = switch (widget.leftRight) {
      DraggableBorders(:final needsDoubleAcceleration) =>
        needsDoubleAcceleration ? 2.0 : 1.0,
      NoneDraggableBorders() => 0.0,
    };

    final topBottomAcceleration = switch (widget.topBottom) {
      DraggableBorders(:final needsDoubleAcceleration) =>
        needsDoubleAcceleration ? 2.0 : 1.0,
      NoneDraggableBorders() => 0.0,
    };

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.leftRight.thickness,
            vertical: widget.topBottom.thickness,
          ),
          child: ConstrainedBox(
            constraints: ourConstraints,
            child: widget.child,
          ),
        ),

        // If you are wondering why this is using a Stack:
        // This way, widget.child is layouted first and
        // the DraggableRegions can use the intrinsic size
        // of the child to layout themselves.
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.topBottom case DraggableBorders(
                :final enableStartBorder,
              ))
                if (enableStartBorder)
                  Row(
                    children: [
                      if (widget.leftRight case DraggableBorders(
                        :final enableStartBorder,
                      ))
                        if (enableStartBorder)
                          DraggableRegion(
                            accelerationAndDirection: Offset(
                              -leftRightAcceleration,
                              -topBottomAcceleration,
                            ),
                            onUpdate: (unboundedValue) {
                              var dirty = false;
                              if (topBottomMinDraggableValue == null ||
                                  unboundedValue.dy >
                                      topBottomMinDraggableValue) {
                                maxHeight = unboundedValue.dy;
                                dirty = true;
                              }
                              if (leftRightMinDraggableValue == null ||
                                  unboundedValue.dx >
                                      leftRightMinDraggableValue) {
                                maxWidth = unboundedValue.dx;
                                dirty = true;
                              }
                              if (dirty) {
                                setState(() {});
                              }
                            },
                            initial: Offset(maxWidth, maxHeight),
                            child: SizedBox(
                              height: widget.topBottom.thickness,
                              width: widget.leftRight.thickness,
                              child: const ColoredBox(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      Flexible(
                        child: DraggableRegion(
                          accelerationAndDirection: Offset(
                            0,
                            -topBottomAcceleration,
                          ),
                          onUpdate: (unboundedValue) {
                            if (topBottomMinDraggableValue != null &&
                                unboundedValue.dy <
                                    topBottomMinDraggableValue) {
                              return;
                            }
                            setState(() {
                              maxHeight = unboundedValue.dy;
                            });
                          },
                          initial: Offset(0, maxHeight),
                          child: SizedBox(
                            height: widget.topBottom.thickness,
                            width: double.infinity,
                            child: const ColoredBox(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      if (widget.leftRight case DraggableBorders(
                        :final enableEndBorder,
                      ))
                        if (enableEndBorder)
                          DraggableRegion(
                            accelerationAndDirection: Offset(
                              leftRightAcceleration,
                              -topBottomAcceleration,
                            ),
                            onUpdate: (unboundedValue) {
                              var dirty = false;
                              if (topBottomMinDraggableValue == null ||
                                  unboundedValue.dy >
                                      topBottomMinDraggableValue) {
                                maxHeight = unboundedValue.dy;
                                dirty = true;
                              }
                              if (leftRightMinDraggableValue == null ||
                                  unboundedValue.dx >
                                      leftRightMinDraggableValue) {
                                maxWidth = unboundedValue.dx;
                                dirty = true;
                              }
                              if (dirty) {
                                setState(() {});
                              }
                            },
                            initial: Offset(maxWidth, maxHeight),
                            child: SizedBox(
                              height: widget.topBottom.thickness,
                              width: widget.leftRight.thickness,
                              child: const ColoredBox(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                    ],
                  ),
              Flexible(
                child: Row(
                  children: [
                    if (widget.leftRight case DraggableBorders(
                      :final enableStartBorder,
                    ))
                      if (enableStartBorder)
                        DraggableRegion(
                          accelerationAndDirection: Offset(
                            -leftRightAcceleration,
                            0,
                          ),
                          onUpdate: (unboundedValue) {
                            if (leftRightMinDraggableValue != null &&
                                unboundedValue.dx <
                                    leftRightMinDraggableValue) {
                              return;
                            }
                            setState(() {
                              maxWidth = unboundedValue.dx;
                            });
                          },
                          initial: Offset(maxWidth, 0),
                          child: SizedBox(
                            width: widget.leftRight.thickness,
                            height: double.infinity,
                            child: const ColoredBox(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                    const Spacer(),
                    if (widget.leftRight case DraggableBorders(
                      :final enableEndBorder,
                    ))
                      if (enableEndBorder)
                        DraggableRegion(
                          accelerationAndDirection: Offset(
                            leftRightAcceleration,
                            0,
                          ),
                          onUpdate: (unboundedValue) {
                            if (leftRightMinDraggableValue != null &&
                                unboundedValue.dx <
                                    leftRightMinDraggableValue) {
                              return;
                            }
                            setState(() {
                              maxWidth = unboundedValue.dx;
                            });
                          },
                          initial: Offset(maxWidth, 0),
                          child: SizedBox(
                            width: widget.leftRight.thickness,
                            height: double.infinity,
                            child: const ColoredBox(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              if (widget.topBottom case DraggableBorders(
                :final enableEndBorder,
              ))
                if (enableEndBorder)
                  Row(
                    children: [
                      if (widget.leftRight case DraggableBorders(
                        :final enableStartBorder,
                      ))
                        if (enableStartBorder)
                          DraggableRegion(
                            accelerationAndDirection: Offset(
                              -leftRightAcceleration,
                              topBottomAcceleration,
                            ),
                            onUpdate: (unboundedValue) {
                              var dirty = false;
                              if (topBottomMinDraggableValue == null ||
                                  unboundedValue.dy >
                                      topBottomMinDraggableValue) {
                                maxHeight = unboundedValue.dy;
                                dirty = true;
                              }
                              if (leftRightMinDraggableValue == null ||
                                  unboundedValue.dx >
                                      leftRightMinDraggableValue) {
                                maxWidth = unboundedValue.dx;
                                dirty = true;
                              }
                              if (dirty) {
                                setState(() {});
                              }
                            },
                            initial: Offset(maxWidth, maxHeight),
                            child: SizedBox(
                              height: widget.topBottom.thickness,
                              width: widget.leftRight.thickness,
                              child: const ColoredBox(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      Flexible(
                        child: DraggableRegion(
                          accelerationAndDirection: Offset(
                            0,
                            topBottomAcceleration,
                          ),
                          onUpdate: (unboundedValue) {
                            if (topBottomMinDraggableValue != null &&
                                unboundedValue.dy <
                                    topBottomMinDraggableValue) {
                              return;
                            }
                            setState(() {
                              maxHeight = unboundedValue.dy;
                            });
                          },
                          initial: Offset(0, maxHeight),
                          child: SizedBox(
                            height: widget.topBottom.thickness,
                            width: double.infinity,
                            child: const ColoredBox(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      if (widget.leftRight case DraggableBorders(
                        :final enableEndBorder,
                      ))
                        if (enableEndBorder)
                          DraggableRegion(
                            accelerationAndDirection: Offset(
                              leftRightAcceleration,
                              topBottomAcceleration,
                            ),
                            onUpdate: (unboundedValue) {
                              var dirty = false;
                              if (topBottomMinDraggableValue == null ||
                                  unboundedValue.dy >
                                      topBottomMinDraggableValue) {
                                maxHeight = unboundedValue.dy;
                                dirty = true;
                              }
                              if (leftRightMinDraggableValue == null ||
                                  unboundedValue.dx >
                                      leftRightMinDraggableValue) {
                                maxWidth = unboundedValue.dx;
                                dirty = true;
                              }
                              if (dirty) {
                                setState(() {});
                              }
                            },
                            initial: Offset(maxWidth, maxHeight),
                            child: SizedBox(
                              height: widget.topBottom.thickness,
                              width: widget.leftRight.thickness,
                              child: const ColoredBox(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                    ],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
