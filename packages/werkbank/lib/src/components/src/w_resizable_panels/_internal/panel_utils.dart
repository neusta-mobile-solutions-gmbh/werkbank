import 'dart:math';
import 'dart:ui';

import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';

mixin PanelCalcMixin {
  double maxPanelWidth(double maxWidth) => max(
    maxWidth * WPanelController.maxRelativPanelWidth,
    WPanelController.minWidth,
  );

  // TODO: Unused. Remove?
  double appropriatePanelWidth(double maxWidth) => lerpDouble(
    WPanelController.minWidth,
    maxWidth,
    // Room for improvement
    0.5,
  )!;

  // TODO: Unused. Remove?
  bool initialVisible(double maxWidth) {
    return WBreakpoints.panelVisibilityBreakpoint < maxWidth;
  }

  bool visibleWithThreshold(
    double maxWidth, {
    required bool currentlyVisible,
  }) {
    final threshold = currentlyVisible ? -30.0 : 30.0;
    return (WBreakpoints.panelVisibilityBreakpoint + threshold) < maxWidth;
  }
}
