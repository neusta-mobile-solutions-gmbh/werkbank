import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/axis_drag_gesture_detector.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_layout.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/ruler_overlay.dart';
import 'package:werkbank/werkbank.dart';

class ConstraintsGestures extends StatelessWidget {
  const ConstraintsGestures({
    super.key,
    required this.child,
    required this.constraintsMode,
    required this.onEndOrCancel,
    required this.viewConstraintsListenable,
    required this.layoutChangedListenable,
    required this.onStartUpdatingViewConstraints,
    required this.onViewConstraintsUpdate,
    required this.onReset,
    required this.rulerCorner,
    required this.hRuler,
    required this.vRuler,
  });

  final Widget child;
  final ConstraintsMode constraintsMode;
  final VoidCallback? onEndOrCancel;

  final ValueListenable<ViewConstraints> viewConstraintsListenable;
  final ValueListenable<LayoutInfo?> layoutChangedListenable;
  final ValueChanged<ViewConstraints> onStartUpdatingViewConstraints;
  final ValueChanged<ViewConstraints> onViewConstraintsUpdate;
  final ValueChanged<Axis?> onReset;

  final Widget rulerCorner;
  final Widget hRuler;
  final Widget vRuler;

  void _updateViewConstraints(
    Offset offset,
    Axis? axis,
    ValueChanged<ViewConstraints> callback,
  ) {
    final viewConstraints = viewConstraintsListenable.value;
    final layoutInfo = layoutChangedListenable.value;
    if (layoutInfo == null) {
      return;
    }
    final transform = layoutInfo.transform;
    final size = layoutInfo.size;
    final inverseTransform = Matrix4.tryInvert(transform);
    if (inverseTransform == null) {
      return;
    }
    final localOffset = MatrixUtils.transformPoint(
      PointerEvent.removePerspectiveTransform(inverseTransform),
      offset,
    );
    final localCenter = size.center(Offset.zero);
    final centerOffset = localOffset - localCenter;
    final width = switch (axis) {
      Axis.horizontal || null => (centerOffset.dx * 2).abs(),
      Axis.vertical => null,
    };
    final height = switch (axis) {
      Axis.horizontal => null,
      Axis.vertical || null => (centerOffset.dy * 2).abs(),
    };
    final newViewConstraints = switch (constraintsMode) {
      ConstraintsMode.min =>
        viewConstraints
            .copyWith(
              minWidth: width,
              minHeight: height,
            )
            .normalizeWithMinPriority(),
      ConstraintsMode.max =>
        viewConstraints
            .copyWith(
              maxWidth: width == null ? null : () => width,
              maxHeight: height == null ? null : () => height,
            )
            .normalizeWithMaxPriority(),
      ConstraintsMode.tightOneAxis ||
      ConstraintsMode.bothTight => viewConstraints.copyWith(
        minWidth: width,
        maxWidth: width == null ? null : () => width,
        minHeight: height,
        maxHeight: height == null ? null : () => height,
      ),
    };

    callback(newViewConstraints);
  }

  void _onStartOffsetUpdate(Offset offset, Axis? axis) {
    _updateViewConstraints(offset, axis, onStartUpdatingViewConstraints);
  }

  void _onOffsetUpdate(Offset offset, Axis? axis) {
    _updateViewConstraints(offset, axis, onViewConstraintsUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final bothAxesGesturesEnabled = constraintsMode.supportsBothAxes;

    return ConstraintsLayout(
      rulerCorner: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onDoubleTap: () => onReset.call(null),
          child: rulerCorner,
        ),
      ),
      hRuler: AxisDragGestureDetector(
        axis: GestureAxis.horizontal,
        onStartOffsetUpdate: (offset) =>
            _onStartOffsetUpdate(offset, Axis.horizontal),
        onOffsetUpdate: (offset) => _onOffsetUpdate(offset, Axis.horizontal),
        onSecondaryTap: () => onReset.call(Axis.horizontal),
        onEndOrCancel: onEndOrCancel,
        child: hRuler,
      ),
      vRuler: AxisDragGestureDetector(
        axis: GestureAxis.vertical,
        onStartOffsetUpdate: (offset) =>
            _onStartOffsetUpdate(offset, Axis.vertical),
        onOffsetUpdate: (offset) => _onOffsetUpdate(offset, Axis.vertical),
        onSecondaryTap: () => onReset.call(Axis.vertical),
        onEndOrCancel: onEndOrCancel,
        child: vRuler,
      ),
      child: AxisDragGestureDetector(
        axis: GestureAxis.both,
        enabled: bothAxesGesturesEnabled,
        onStartOffsetUpdate: (offset) => _onStartOffsetUpdate(offset, null),
        onOffsetUpdate: (offset) => _onOffsetUpdate(offset, null),
        onEndOrCancel: onEndOrCancel,
        child: child,
      ),
    );
  }
}
