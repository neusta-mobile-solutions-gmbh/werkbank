import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Tries to limit either the width or height
/// (depending on the [constrainedAxis]) to [softMaxAxisConstraint].
/// If the child's minimum intrinsic size (given the incoming max constraints
/// in the cross axis) is less than [softMaxAxisConstraint], the child's
/// minimum intrinsic size is used as max constraints for the child.
class SoftMaxConstrainedBox extends SingleChildRenderObjectWidget {
  const SoftMaxConstrainedBox({
    super.key,
    required this.constrainedAxis,
    required this.softMaxAxisConstraint,
    super.child,
  }) : assert(
         softMaxAxisConstraint >= 0,
         'softMaxAxisConstraint must be >= 0',
       );

  final Axis constrainedAxis;
  final double softMaxAxisConstraint;

  @override
  RenderSoftMaxConstrainedBox createRenderObject(BuildContext context) {
    return RenderSoftMaxConstrainedBox(
      constrainedAxis: constrainedAxis,
      softMaxAxisConstraint: softMaxAxisConstraint,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSoftMaxConstrainedBox renderObject,
  ) {
    renderObject
      ..constrainedAxis = constrainedAxis
      ..softMaxAxisConstraint = softMaxAxisConstraint;
  }
}

class RenderSoftMaxConstrainedBox extends RenderProxyBox {
  RenderSoftMaxConstrainedBox({
    required Axis constrainedAxis,
    required double softMaxAxisConstraint,
    RenderBox? child,
  }) : _constrainedAxis = constrainedAxis,
       _softMaxAxisConstraint = softMaxAxisConstraint,
       super(child);

  Axis get constrainedAxis => _constrainedAxis;
  Axis _constrainedAxis;

  set constrainedAxis(Axis value) {
    if (value == _constrainedAxis) {
      return;
    }
    _constrainedAxis = value;
    markNeedsLayout();
  }

  double get softMaxAxisConstraint => _softMaxAxisConstraint;
  double _softMaxAxisConstraint;

  set softMaxAxisConstraint(double value) {
    assert(value >= 0, 'softMaxAxisConstraint must be >= 0');
    if (value == _softMaxAxisConstraint) {
      return;
    }
    _softMaxAxisConstraint = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return super.computeMinIntrinsicWidth(
      switch (constrainedAxis) {
        Axis.horizontal => height,
        Axis.vertical => min(height, softMaxAxisConstraint),
      },
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    switch (constrainedAxis) {
      case Axis.horizontal:
        final childIntrinsicWidth = super.computeMaxIntrinsicWidth(height);
        if (childIntrinsicWidth <= softMaxAxisConstraint) {
          return childIntrinsicWidth;
        }
        return max(
          softMaxAxisConstraint,
          super.computeMinIntrinsicWidth(height),
        );
      case Axis.vertical:
        final double heightConstraint;
        if (height <= softMaxAxisConstraint) {
          heightConstraint = height;
        } else {
          heightConstraint = max(
            softMaxAxisConstraint,
            super.computeMinIntrinsicHeight(double.infinity),
          );
        }
        return super.computeMaxIntrinsicWidth(heightConstraint);
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(
      switch (constrainedAxis) {
        Axis.horizontal => min(width, softMaxAxisConstraint),
        Axis.vertical => width,
      },
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    switch (constrainedAxis) {
      case Axis.horizontal:
        final double widthConstraint;
        if (width <= softMaxAxisConstraint) {
          widthConstraint = width;
        } else {
          widthConstraint = max(
            softMaxAxisConstraint,
            super.computeMinIntrinsicWidth(double.infinity),
          );
        }
        return super.computeMaxIntrinsicHeight(widthConstraint);
      case Axis.vertical:
        final childIntrinsicHeight = super.computeMaxIntrinsicHeight(width);
        if (childIntrinsicHeight <= softMaxAxisConstraint) {
          return childIntrinsicHeight;
        }
        return max(
          softMaxAxisConstraint,
          super.computeMinIntrinsicHeight(width),
        );
    }
  }

  BoxConstraints _childConstraints(
    RenderBox child,
    BoxConstraints constraints,
  ) {
    final newConstraints = switch (constrainedAxis) {
      Axis.horizontal => BoxConstraints(
        maxWidth: max(
          softMaxAxisConstraint,
          child.getMinIntrinsicWidth(constraints.maxHeight),
        ),
      ),
      Axis.vertical => BoxConstraints(
        maxHeight: max(
          softMaxAxisConstraint,
          child.getMinIntrinsicHeight(constraints.maxWidth),
        ),
      ),
    };
    return newConstraints.enforce(constraints);
  }

  Size _computeSize({
    required ChildLayouter layoutChild,
    required BoxConstraints constraints,
  }) {
    final child = this.child;
    return child == null
        ? constraints.smallest
        : layoutChild(child, _childConstraints(child, constraints));
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _computeSize(
      layoutChild: ChildLayoutHelper.dryLayoutChild,
      constraints: constraints,
    );
  }

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final child = this.child;
    return child?.getDryBaseline(
      _childConstraints(child, constraints),
      baseline,
    );
  }

  @override
  void performLayout() {
    size = _computeSize(
      layoutChild: ChildLayoutHelper.layoutChild,
      constraints: constraints,
    );
  }
}
