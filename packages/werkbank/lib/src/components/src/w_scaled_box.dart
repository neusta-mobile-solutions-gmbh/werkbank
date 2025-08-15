import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart';

/// {@category Werkbank Components}
class WScaledBox extends SingleChildRenderObjectWidget {
  const WScaledBox({
    super.key,
    this.scale = 1,
    this.scaleX = 1,
    this.scaleY = 1,
    super.child,
  }) : assert(scale > 0, 'scale must be greater than 0'),
       assert(scaleX > 0, 'scaleX must be greater than 0'),
       assert(scaleY > 0, 'scaleY must be greater than 0');

  final double scale;
  final double scaleX;
  final double scaleY;

  @override
  RenderSScaledBox createRenderObject(BuildContext context) {
    return RenderSScaledBox(
      scaleX: scaleX * scale,
      scaleY: scaleY * scale,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSScaledBox renderObject,
  ) {
    renderObject
      ..scaleX = scaleX * scale
      ..scaleY = scaleY * scale;
  }
}

class RenderSScaledBox extends RenderProxyBox {
  RenderSScaledBox({
    required double scaleX,
    required double scaleY,
    RenderBox? child,
  }) : _scaleX = scaleX,
       _scaleY = scaleY,
       super(child);

  double get scaleX => _scaleX;
  double _scaleX;

  set scaleX(double value) {
    if (value == _scaleX) {
      return;
    }
    assert(value > 0, 'scaleX must be greater than 0');
    assert(value.isFinite, 'scaleX must be finite');
    _scaleX = value;
    markNeedsLayout();
  }

  double get scaleY => _scaleY;
  double _scaleY;

  set scaleY(double value) {
    if (value == _scaleY) {
      return;
    }
    assert(value > 0, 'scaleY must be greater than 0');
    assert(value.isFinite, 'scaleY must be finite');
    _scaleY = value;
    markNeedsLayout();
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super.computeMaxIntrinsicHeight(width / scaleX) * scaleY;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return super.computeMaxIntrinsicWidth(height / scaleY) * scaleX;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(width / scaleX) * scaleY;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return super.computeMinIntrinsicWidth(height / scaleY) * scaleX;
  }

  BoxConstraints _childConstraints(BoxConstraints constraints) =>
      constraints.scale(1 / scaleX, 1 / scaleY);

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final childBaseline = super.computeDistanceToActualBaseline(baseline);
    if (childBaseline == null) {
      return null;
    }
    return childBaseline * scaleY;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(
      super
          .computeDryLayout(_childConstraints(constraints))
          .scale(scaleX, scaleY),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(child.size.scale(scaleX, scaleY));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    if (scaleX == 1 && scaleY == 1) {
      super.paint(context, offset);
      return;
    }
    layer = context.pushTransform(
      needsCompositing,
      offset,
      Matrix4.diagonal3Values(scaleX, scaleY, 1),
      super.paint,
      oldLayer: layer as TransformLayer?,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) {
      return false;
    }
    return result.addWithPaintTransform(
      transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
      position: position,
      hitTest: (result, position) =>
          super.hitTestChildren(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.scaleByVector3(Vector3(scaleX, scaleY, 1));
  }
}

extension on Size {
  Size scale(double scaleX, double scaleY) {
    return Size(width * scaleX, height * scaleY);
  }
}

extension on BoxConstraints {
  BoxConstraints scale(double scaleX, double scaleY) {
    return BoxConstraints(
      minWidth: minWidth * scaleX,
      maxWidth: maxWidth * scaleX,
      minHeight: minHeight * scaleY,
      maxHeight: maxHeight * scaleY,
    );
  }
}
