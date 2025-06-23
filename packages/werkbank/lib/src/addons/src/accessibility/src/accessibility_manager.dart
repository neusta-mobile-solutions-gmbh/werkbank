import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/colorblindness_overlay/colorblindness_type.dart';

class AccessibilityManager extends StatefulWidget {
  const AccessibilityManager({
    super.key,
    required this.child,
  });

  static double textScaleFactorOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .textScaleFactor;
  }

  static void setTextScaleFactor(
    BuildContext context, {
    required double textScaleFactor,
  }) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setTextScaleFactor(textScaleFactor: textScaleFactor);
  }

  static bool boldTextOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .boldText;
  }

  static void setBoldText(BuildContext context, {required bool boldText}) {
    context.findAncestorStateOfType<_AccessibilityManagerState>()!.setBoldText(
      boldText: boldText,
    );
  }

  static SemanticMode semanticModeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .semanticMode;
  }

  static void setSemanticMode(
    BuildContext context,
    SemanticMode semanticMode,
  ) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setSemanticMode(semanticMode: semanticMode);
  }

  static ColorBlindnessType? simulatedColorBlindnessTypeOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .simulatedColorBlindnessType;
  }

  static void setSimulatedColorBlindnessType(
    BuildContext context,
    ColorBlindnessType? simulatedColorBlindnessType,
  ) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setSimulatedColorBlindnessType(
          simulatedColorBlindnessType: simulatedColorBlindnessType,
        );
  }

  final Widget child;

  @override
  State<AccessibilityManager> createState() => _AccessibilityManagerState();
}

class _AccessibilityManagerState extends State<AccessibilityManager> {
  double textScaleFactor = 1;
  bool boldText = false;
  SemanticMode semanticMode = SemanticMode.none;
  ColorBlindnessType? simulatedColorBlindnessType;
  void setTextScaleFactor({required double textScaleFactor}) {
    setState(() {
      this.textScaleFactor = textScaleFactor;
    });
  }

  void setBoldText({required bool boldText}) {
    setState(() {
      this.boldText = boldText;
    });
  }

  void setSemanticMode({required SemanticMode semanticMode}) {
    setState(() {
      this.semanticMode = semanticMode;
    });
  }

  void setSimulatedColorBlindnessType({
    required ColorBlindnessType? simulatedColorBlindnessType,
  }) {
    setState(() {
      this.simulatedColorBlindnessType = simulatedColorBlindnessType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AccessibilityState(
      boldText: boldText,
      textScaleFactor: textScaleFactor,
      semanticMode: semanticMode,
      simulatedColorBlindnessType: simulatedColorBlindnessType,
      child: widget.child,
    );
  }
}

class _AccessibilityState extends InheritedWidget {
  const _AccessibilityState({
    required this.textScaleFactor,
    required this.boldText,
    required this.semanticMode,
    required this.simulatedColorBlindnessType,
    required super.child,
  });

  final double textScaleFactor;
  final bool boldText;
  final SemanticMode semanticMode;
  final ColorBlindnessType? simulatedColorBlindnessType;

  @override
  bool updateShouldNotify(_AccessibilityState oldWidget) {
    return textScaleFactor != oldWidget.textScaleFactor ||
        boldText != oldWidget.boldText ||
        semanticMode != oldWidget.semanticMode ||
        simulatedColorBlindnessType != oldWidget.simulatedColorBlindnessType;
  }
}

enum SemanticMode {
  none,
  overlay,
  inspection,
}
