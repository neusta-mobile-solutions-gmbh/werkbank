import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Werkbank Components}
class WLayoutReference extends SingleChildRenderObjectWidget {
  const WLayoutReference({
    super.key,
    required this.link,
    required Widget super.child,
  });

  final LayoutReferenceLink link;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLayoutReference(link);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderLayoutReference renderObject,
  ) {
    renderObject.link = link;
  }
}

class RenderLayoutReference extends RenderProxyBox {
  RenderLayoutReference(this._link);

  LayoutReferenceLink _link;

  LayoutReferenceLink get link => _link;

  set link(LayoutReferenceLink value) {
    if (_link == value) {
      return;
    }
    if (attached) {
      _link._unregisterRenderObject(this);
      value._registerRenderObject(this);
    }
    _link = value;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _link._registerRenderObject(this);
  }

  @override
  void detach() {
    _link._unregisterRenderObject(this);
    super.detach();
  }
}

class LayoutReferenceLink with SingleAttachmentMixin<RenderObject> {
  RenderObject? get renderObject => entity;

  void _registerRenderObject(RenderObject renderObject) {
    attach(renderObject);
  }

  void _unregisterRenderObject(RenderObject renderObject) {
    detach(renderObject);
  }
}
