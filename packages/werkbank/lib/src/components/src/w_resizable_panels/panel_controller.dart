import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WPanelController {
  WPanelController({
    required double initialLeftWidth,
    required double initialRightWidth,
    bool leftInitiallyVisible = true,
    bool rightInitiallyVisible = true,
  }) : leftWidth = ValueNotifier<double>(initialLeftWidth),
       rightWidth = ValueNotifier<double>(initialRightWidth),
       leftExpanded = ValueNotifier<bool>(leftInitiallyVisible),
       rightExpanded = ValueNotifier<bool>(rightInitiallyVisible);

  bool get atLeastOneIsCurrentlyVisible =>
      leftExpanded.value || rightExpanded.value;

  void showBoth() {
    leftExpanded.value = true;
    rightExpanded.value = true;
  }

  void hideBoth() {
    leftExpanded.value = false;
    rightExpanded.value = false;
  }

  void toggle() {
    if (atLeastOneIsCurrentlyVisible) {
      hideBoth();
    } else {
      showBoth();
    }
  }

  void dispose() {
    leftWidth.dispose();
    rightWidth.dispose();
    leftExpanded.dispose();
    rightExpanded.dispose();
  }

  final ValueNotifier<double> leftWidth;
  final ValueNotifier<double> rightWidth;
  final ValueNotifier<bool> leftExpanded;
  final ValueNotifier<bool> rightExpanded;
}
