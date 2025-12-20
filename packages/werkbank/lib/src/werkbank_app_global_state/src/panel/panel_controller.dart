import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class PanelController extends GlobalStateController {
  PanelController({
    required this.vsync,
  }) {
    Listenable.merge([
      wPanelController.preferredLeft,
      wPanelController.preferredRight,
      // TODO: This updates too often, find a better way.
      wPanelController.leftAnimation,
      wPanelController.rightAnimation,
    ]).addListener(notifyListeners);
  }

  static const _leftPanelWidthKey = 'leftPanelWidth';
  static const _rightPanelWidthKey = 'rightPanelWidth';
  static const _leftExpandedKey = 'leftExpanded';
  static const _rightExpandedKey = 'rightExpanded';

  final TickerProvider vsync;

  late final WPanelController wPanelController = WPanelController(
    vsync: vsync,
    // TODO: Remove argument? This will be updated later anyway.
    initialMaxWidth: double.infinity,
    // TODO: Add way to calculate fitting initial width?
    initialWidth: 500,
  );

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json case {
      _leftPanelWidthKey: final double leftWidth,
      _rightPanelWidthKey: final double rightWidth,
      _leftExpandedKey: final bool leftExpanded,
      _rightExpandedKey: final bool rightExpanded,
    }) {
      wPanelController.proposePreferredLeft(leftWidth);
      wPanelController.proposePreferredRight(rightWidth);
      // TODO: This will trigger animations on load, find a better way.
      unawaited(
        leftExpanded
            ? wPanelController.showLeft()
            : wPanelController.hideLeft(),
      );
      unawaited(
        rightExpanded
            ? wPanelController.showRight()
            : wPanelController.hideRight(),
      );
    }
  }

  @override
  Object? toJson() {
    return {
      _leftPanelWidthKey: wPanelController.preferredLeft.value,
      _rightPanelWidthKey: wPanelController.preferredRight.value,
      // TODO: Refactor so threshold is not needed.
      _leftExpandedKey: wPanelController.leftAnimation.value > 0.5,
      _rightExpandedKey: wPanelController.rightAnimation.value > 0.5,
    };
  }

  @override
  void dispose() {
    wPanelController.dispose();
    super.dispose();
  }
}
