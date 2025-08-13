import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A sliver that can be pinned to the top of the viewport.
/// It behaves almost like this:
/// ```dart
/// if (pinned)
///   PinnedHeaderSliver(child: child)
/// else
///   SliverToBoxAdapter(child: child),
/// ```
/// but for the above example, the child-widget will be
/// re-created every time the pinned property changes.
///
/// This widget is more efficient because it reuses the child-widget
/// and only changes the layout behavior.
class SliverPinnedHeader extends SingleChildRenderObjectWidget {
  const SliverPinnedHeader({
    required this.pinned,
    required super.child,
    super.key,
  });

  final bool pinned;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverPinnedHeader(
      pinned: pinned,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverPinnedHeader renderObject,
  ) {
    renderObject.pinned = pinned;
  }
}

class RenderSliverPinnedHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverPinnedHeader({
    required this.pinned,
    super.child,
  });

  bool pinned;

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = switch (constraints.axis) {
      Axis.horizontal => child!.size.width,
      Axis.vertical => child!.size.height,
    };
    if (pinned) {
      _performPinnedBoxLayout(childExtent);
    } else {
      _performSliverToBoxLayout(childExtent);
    }
  }

  void _performPinnedBoxLayout(double childExtent) {
    final paintedChildExtent = min(
      childExtent,
      constraints.remainingPaintExtent - constraints.overlap,
    );
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildExtent,
      maxPaintExtent: childExtent,
      hasVisualOverflow: paintedChildExtent < childExtent,
      maxScrollObstructionExtent: childExtent,
      paintOrigin: constraints.overlap,
      layoutExtent: max(0, paintedChildExtent - constraints.scrollOffset),
    );

    // Usually setChildParentData(child!, constraints, geometry!);
    // would handle this,
    (child!.parentData! as SliverPhysicalParentData).paintOffset = Offset.zero;
    // but for the pinned case, we need to set the paint offset manually.
    // since we dont want it to move with the scroll.
    // This is only necessary because
    // _performSliverToBoxLayout -> setChildParentData
    // changes the paint offset and therefore we need to reset it here.
  }

  /// See [RenderSliverToBoxAdapter.performLayout]
  void _performSliverToBoxLayout(double childExtent) {
    final paintedChildSize = calculatePaintOffset(
      constraints,
      from: 0,
      to: childExtent,
    );
    final cacheExtent = calculateCacheOffset(
      constraints,
      from: 0,
      to: childExtent,
    );

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow:
          childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    return pinned ? 0 : -constraints.scrollOffset;
  }
}
