import 'dart:math';
import 'dart:ui';

import 'package:werkbank/src/werkbank_internal.dart';

mixin PanelCalcMixin {
  double maxPanelWidth(double maxWidth) => max(
    maxWidth * PanelController.maxRelativPanelWidth,
    PanelController.minWidth,
  );

  double appropriatePanelWidth(double maxWidth) => lerpDouble(
    PanelController.minWidth,
    maxWidth,
    // Room for improvement
    0.5,
  )!;

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
