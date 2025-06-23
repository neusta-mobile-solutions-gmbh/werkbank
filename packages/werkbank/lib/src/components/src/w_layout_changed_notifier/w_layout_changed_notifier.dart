import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/components/components.dart';

class LayoutInfo {
  LayoutInfo(this.size, this.transform);

  /// The size of the measured [WLayoutChangedNotifier].
  /// This size is not relative to any [WLayoutReference] ancestor or
  /// the [PipelineOwner.rootNode] but simply the size within the
  /// reference frame of the [WLayoutChangedNotifier].
  final Size size;

  /// The transform of the measured [WLayoutChangedNotifier]
  /// relative to the linked [WLayoutReference]
  /// ancestor or the [PipelineOwner.rootNode] if there
  /// is no [WLayoutReference].
  final Matrix4 transform;
}

/// A widget which notifies calls a given [onLayoutChanged] callback
/// when its size or relative transform changes.
/// The transform is relative to the linked [WLayoutReference] widget or the
/// [PipelineOwner.rootNode] if [link] is `null`.
///
/// The callback is called before the paint phase of the frame, so it can be
/// used to influence the paint phase, for example by changing the value of
/// the `repaint` [Listenable] passed to a [CustomPainter].
///
/// {@category Werkbank Components}
class WLayoutChangedNotifier extends StatefulWidget {
  const WLayoutChangedNotifier({
    super.key,
    this.link,
    required this.onLayoutChanged,
    required this.child,
  });

  /// A link to an ancestor [WLayoutReference].
  ///
  /// If [link] is `null`, transform will be relative to the
  /// [PipelineOwner.rootNode], so root of the render tree.
  ///
  /// Otherwise the given [LayoutReferenceLink] must be registered to a
  /// single [WLayoutReference] widget, which is an ancestor of this widget.
  final LayoutReferenceLink? link;
  final Widget child;
  final void Function(LayoutInfo layoutInfo) onLayoutChanged;

  @override
  State<WLayoutChangedNotifier> createState() => _SLayoutChangedNotifierState();
}

class _SLayoutChangedNotifierState extends State<WLayoutChangedNotifier> {
  final _measuredWidgetKey = GlobalKey();
  Size? prevSize;
  Matrix4? prevTransform;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _callOnLayoutChanged() {
    final measuredRenderObject =
        _measuredWidgetKey.currentContext!.findRenderObject()! as RenderBox;
    final link = widget.link;
    final RenderObject? referenceRenderObject;
    if (link != null) {
      referenceRenderObject = link.renderObject;
      assert(
        referenceRenderObject != null,
        'The LayoutReferenceLink not registered to a LayoutReference.',
      );
    } else {
      referenceRenderObject = null;
    }
    final newSize = measuredRenderObject.size;
    final newTransform = measuredRenderObject.getTransformTo(
      referenceRenderObject,
    );
    if (prevSize != newSize || prevTransform != newTransform) {
      prevSize = newSize;
      prevTransform = newTransform;
      widget.onLayoutChanged(
        LayoutInfo(
          newSize,
          newTransform,
        ),
      );
    }
  }

  // We center and shrink so that the RepaintBoundary has zero size, which may
  // save some memory because no image has to be cached.
  late final _callerWidget = Center(
    child: SizedBox.shrink(
      // We need a RepaintBoundary here because the _BeforePaintCaller will
      // call markNeedsCompositingBitsUpdate on its parent every frame.
      // Usually this propagates up the tree and mark every ancestor as needing
      // compositing bits update. However this stops at repaint boundaries.
      // This
      child: RepaintBoundary(
        child: _BeforePaintCaller(
          beforePaintCallback: _callOnLayoutChanged,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // The Stack will take the same size as the child, since the
    // fit is StackFit.passthrough and the _callerWidget will be as small as
    // possible.
    return Stack(
      key: _measuredWidgetKey,
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(child: _callerWidget),
        widget.child,
      ],
    );
  }
}

class _BeforePaintCaller extends LeafRenderObjectWidget {
  const _BeforePaintCaller({
    required this.beforePaintCallback,
  });

  final VoidCallback beforePaintCallback;

  @override
  _RenderBeforePaintCaller createRenderObject(BuildContext context) =>
      _RenderBeforePaintCaller(beforePaintCallback);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderBeforePaintCaller renderObject,
  ) {
    renderObject.beforePaintCallback = beforePaintCallback;
  }
}

class _RenderBeforePaintCaller extends RenderBox {
  _RenderBeforePaintCaller(this.beforePaintCallback);

  VoidCallback beforePaintCallback;
  bool calledThisFrame = false;

  // Since this getter is only legal to call after layout, and we are forcing
  // it to be called, the beforePaintCallback is called exactly once during the
  // compositing bits phase.
  @override
  bool get needsCompositing {
    if (!calledThisFrame) {
      beforePaintCallback();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        parent!.markNeedsCompositingBitsUpdate();
        calledThisFrame = false;
      });
    }
    return super.needsCompositing;
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.smallest;
}
