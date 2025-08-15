import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PanelController {
  PanelController({
    required TickerProvider vsync,
    bool initiallyVisible = true,
    required double initialMaxWidth,
    required double initialWidth,
  }) {
    _leftController = AnimationController(
      vsync: vsync,
      value: initiallyVisible ? 1.0 : 0.0,
      duration: Durations.long2,
    );
    _rightController = AnimationController(
      vsync: vsync,
      value: initiallyVisible ? 1.0 : 0.0,
      duration: Durations.long2,
    );
    _preferredLeft = ValueNotifier<double>(initialWidth);
    _preferredRight = ValueNotifier<double>(initialWidth);
    _maxWidth = ValueNotifier<double>(initialMaxWidth);
  }

  late final AnimationController _leftController;
  late final AnimationController _rightController;

  // Relative fade in and out of the absolute width (0-1)
  Animation<double> get leftAnimation =>
      CurveTween(curve: Easing.standard).animate(_leftController.view);
  Animation<double> get rightAnimation =>
      CurveTween(curve: Easing.standard).animate(_rightController.view);

  bool get atLeastOneIsCurrentlyVisible =>
      _leftController.value > 0.0 || _rightController.value > 0.0;

  Future<void> showLeft() async {
    try {
      await Future.wait([
        _leftController.forward().orCancel,
      ]);
    } on TickerCanceled {
      // the animation got canceled
    }
  }

  Future<void> hideLeft() async {
    try {
      await Future.wait([
        _leftController.reverse().orCancel,
      ]);
    } on TickerCanceled {
      // the animation got canceled
    }
  }

  Future<void> showRight() async {
    try {
      await Future.wait([
        _rightController.forward().orCancel,
      ]);
    } on TickerCanceled {
      // the animation got canceled
    }
  }

  Future<void> hideRight() async {
    try {
      await Future.wait([
        _rightController.reverse().orCancel,
      ]);
    } on TickerCanceled {
      // the animation got canceled
    }
  }

  Future<void> show() async {
    await Future.wait([
      showLeft(),
      showRight(),
    ]);
  }

  Future<void> hide() async {
    await Future.wait([
      hideLeft(),
      hideRight(),
    ]);
  }

  Future<void> toggle() async {
    if (atLeastOneIsCurrentlyVisible) {
      await hide();
    } else {
      await show();
    }
  }

  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
  }

  // The absolute width
  late final ValueNotifier<double> _preferredLeft;
  late final ValueNotifier<double> _preferredRight;
  late final ValueNotifier<double> _maxWidth;

  // Prevent writing to the preferred width directly.
  ValueListenable<double> get preferredLeft => _preferredLeft;
  ValueListenable<double> get preferredRight => _preferredRight;
  ValueListenable<double> get maxWidth => _maxWidth;

  // static const initialWidth = 400.0;
  // Not usable below width 200.0, therefore it has a minimum width.
  static const minWidth = 200.0;
  static const verySmallWidth = 10.0;

  static const maxRelativPanelWidth = .45;

  bool proposePreferredLeft(double width) => _proposePreferredWidth(
    width,
    _preferredLeft,
    _leftController,
  );

  bool proposePreferredRight(double width) => _proposePreferredWidth(
    width,
    _preferredRight,
    _rightController,
  );

  bool _proposePreferredWidth(
    double width,
    ValueNotifier<double> preferredWidth,
    AnimationController controller,
  ) {
    if (preferredWidth.value == width) {
      // Nothing to do.
      return true;
    }

    final currentlyInvisible = controller.value == 0;

    final proposalVerySmall = width < verySmallWidth;
    if (proposalVerySmall && !currentlyInvisible) {
      unawaited(controller.animateTo(0, duration: Duration.zero));

      return true;
    }

    final proposalTooSmall = width < minWidth;
    final proposalTooLarge = width > maxWidth.value;
    if (proposalTooSmall || proposalTooLarge) {
      return false;
    }

    if (currentlyInvisible) {
      unawaited(controller.animateTo(1, duration: Duration.zero));
    }
    preferredWidth.value = width;
    return true;
  }

  void updateMaxWidth(double newMaxWidth) {
    assert(newMaxWidth >= minWidth, 'newMaxWidth must be at least $minWidth');
    _maxWidth.value = newMaxWidth;
    _preferredLeft.value = _preferredLeft.value.clamp(minWidth, newMaxWidth);
    _preferredRight.value = _preferredRight.value.clamp(minWidth, newMaxWidth);
  }
}
