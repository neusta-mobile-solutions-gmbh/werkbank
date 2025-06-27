import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IgnorePointerWithSemantics extends SingleChildRenderObjectWidget {
  const IgnorePointerWithSemantics({
    super.key,
    super.child,
    this.ignoring = true,
  });

  final bool ignoring;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderIgnorePointerWithSemantics(ignoring: ignoring);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderIgnorePointerWithSemantics renderObject,
  ) {
    renderObject.ignoring = ignoring;
  }
}

class RenderIgnorePointerWithSemantics extends RenderProxyBox {
  RenderIgnorePointerWithSemantics({this.ignoring = true});

  // It's fine to use a field here instead of the usual getter and setter
  // because we don't need to mark anything as dirty when this changes.
  bool ignoring;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) =>
      !ignoring && super.hitTest(result, position: position);
}
