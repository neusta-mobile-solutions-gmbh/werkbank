import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// This widget is comparable to
/// flutter_staggered_grid_view -> sliver_masonry_grid
/// but it is not lazy and not using slivers.
///
/// If this ever leds to performance issues, switch to sliver_masonry_grid
///
/// {@category Werkbank Components}
class WTwoColsLayout extends StatelessWidget {
  const WTwoColsLayout({
    this.mainAxisSpaceBetween = 16,
    this.crossAxisSpaceBetween = 16,
    this.retainFirstOrder = false,
    required this.children,
    super.key,
  });

  final double mainAxisSpaceBetween;
  final double crossAxisSpaceBetween;
  final bool retainFirstOrder;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _TwoColsLayout(
      mainAxisSpaceBetween: mainAxisSpaceBetween,
      crossAxisSpaceBetween: crossAxisSpaceBetween,
      retainFirstOrder: retainFirstOrder,
      children: children,
    );
  }
}

/// This widget won't complain about overflows, like a normal column would.
/// You need to be careful yourself to not overflow.
class _TwoColsLayout extends MultiChildRenderObjectWidget {
  const _TwoColsLayout({
    required this.mainAxisSpaceBetween,
    required this.crossAxisSpaceBetween,
    required this.retainFirstOrder,
    required super.children,
  });

  final double mainAxisSpaceBetween;
  final double crossAxisSpaceBetween;
  final bool retainFirstOrder;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTwoColsLayout(
      mainAxisSpaceBetween: mainAxisSpaceBetween,
      crossAxisSpaceBetween: crossAxisSpaceBetween,
      retainFirstOrder: retainFirstOrder,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoColsLayout renderObject,
  ) {
    final propertiesChanged =
        renderObject.mainAxisSpaceBetween != mainAxisSpaceBetween ||
        renderObject.crossAxisSpaceBetween != crossAxisSpaceBetween ||
        renderObject.retainFirstOrder != retainFirstOrder;

    if (propertiesChanged) {
      renderObject
        ..mainAxisSpaceBetween = mainAxisSpaceBetween
        ..crossAxisSpaceBetween = crossAxisSpaceBetween
        ..retainFirstOrder = retainFirstOrder
        ..markNeedsLayout();
    }
  }
}

class TwoColsLayoutParentData extends ContainerBoxParentData<RenderBox> {
  int? id;
}

class _ChildData {
  _ChildData({
    required this.id,
    required this.child,
    required this.height,
  });

  final int id;
  final RenderBox child;
  final double height;
}

class RenderTwoColsLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TwoColsLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TwoColsLayoutParentData> {
  RenderTwoColsLayout({
    required this.mainAxisSpaceBetween,
    required this.crossAxisSpaceBetween,
    required this.retainFirstOrder,
  });

  double mainAxisSpaceBetween;
  double crossAxisSpaceBetween;

  bool retainFirstOrder;
  List<_ChildData>? _leftColumn;
  List<_ChildData>? _rightColumn;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TwoColsLayoutParentData) {
      child.parentData = TwoColsLayoutParentData();
    }
  }

  @override
  void performLayout() {
    //  Assign IDs and collect heights
    final childrenData = <_ChildData>[];
    var child = firstChild;
    var id = 0;

    final tightWidth = (constraints.maxWidth - crossAxisSpaceBetween) / 2;

    while (child != null) {
      final childParentData = child.parentData! as TwoColsLayoutParentData;
      child.layout(
        constraints.copyWith(
          maxWidth: tightWidth,
          minWidth: tightWidth,
          minHeight: 0,
        ),
        parentUsesSize: true,
      );
      childParentData.id = id;
      childrenData.add(
        _ChildData(
          id: id,
          child: child,
          height: child.size.height,
        ),
      );
      id++;
      child = childParentData.nextSibling;
    }

    // Sort the children by height and distribute them
    childrenData.sort((a, b) => b.height.compareTo(a.height));

    final retainPreviousOrder =
        retainFirstOrder && _leftColumn != null && _rightColumn != null;

    final leftColumn = <_ChildData>[];
    final rightColumn = <_ChildData>[];
    var leftHeight = 0.0;
    var rightHeight = 0.0;

    for (final data in childrenData) {
      if (!retainPreviousOrder) {
        if (leftHeight <= rightHeight) {
          leftColumn.add(data);
          leftHeight += data.height;
        } else {
          rightColumn.add(data);
          rightHeight += data.height;
        }
      } else {
        final isInLeftColumn = _leftColumn!.any((item) => item.id == data.id);
        if (isInLeftColumn) {
          leftColumn.add(data);
          leftHeight += data.height;
        } else // is in right column
        {
          rightColumn.add(data);
          rightHeight += data.height;
        }
      }
    }

    _leftColumn = leftColumn;
    _rightColumn = rightColumn;

    // Restore original order and position
    child = firstChild;
    final rightColumnDx = (constraints.maxWidth + crossAxisSpaceBetween) / 2;
    var leftYOffset = 0.0;
    var rightYOffset = 0.0;

    while (child != null) {
      final childParentData = child.parentData! as TwoColsLayoutParentData;
      final childData = childrenData.firstWhere(
        (data) => data.id == childParentData.id,
      );

      if (_leftColumn!.contains(childData)) {
        childParentData.offset = Offset(0, leftYOffset);
        leftYOffset += child.size.height + mainAxisSpaceBetween;
      } else if (_rightColumn!.contains(childData)) {
        childParentData.offset = Offset(rightColumnDx, rightYOffset);
        rightYOffset += child.size.height + mainAxisSpaceBetween;
      }

      child = childParentData.nextSibling;
    }

    // Calculate the size of the layout
    final finalHeight = max(leftYOffset, rightYOffset) - mainAxisSpaceBetween;
    size = constraints.constrain(Size(constraints.maxWidth, finalHeight));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    return defaultPaint(context, offset);
  }
}
