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

  static SemanticsScope semanticsScopeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .semanticsScope;
  }

  static void setSemanticsScope(
    BuildContext context,
    SemanticsScope semanticsScope,
  ) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setSemanticsScope(semanticsScope: semanticsScope);
  }

  static bool showMergedSemanticsNodesOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .showMergedSemanticsNodes;
  }

  static void setShowMergedSemanticsNodes(
    BuildContext context, {
    required bool showMergedSemanticsNodes,
  }) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setShowMergedSemanticsNodes(
          showMergedSemanticsNodes: showMergedSemanticsNodes,
        );
  }

  static bool showHiddenSemanticsNodesOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .showHiddenSemanticsNodes;
  }

  static void setShowHiddenSemanticsNodes(
    BuildContext context, {
    required bool showHiddenSemanticsNodes,
  }) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setShowHiddenSemanticsNodes(
          showHiddenSemanticsNodes: showHiddenSemanticsNodes,
        );
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
  SemanticsScope semanticsScope = SemanticsScope.useCase;
  bool showMergedSemanticsNodes = false;
  bool showHiddenSemanticsNodes = true;
  ColorBlindnessType? simulatedColorBlindnessType;

  void setTextScaleFactor({required double textScaleFactor}) =>
      setState(() => this.textScaleFactor = textScaleFactor);

  void setBoldText({required bool boldText}) =>
      setState(() => this.boldText = boldText);

  void setSemanticMode({required SemanticMode semanticMode}) =>
      setState(() => this.semanticMode = semanticMode);

  void setSemanticsScope({required SemanticsScope semanticsScope}) =>
      setState(() => this.semanticsScope = semanticsScope);

  void setShowMergedSemanticsNodes({required bool showMergedSemanticsNodes}) =>
      setState(() => this.showMergedSemanticsNodes = showMergedSemanticsNodes);

  void setShowHiddenSemanticsNodes({required bool showHiddenSemanticsNodes}) =>
      setState(() => this.showHiddenSemanticsNodes = showHiddenSemanticsNodes);

  void setSimulatedColorBlindnessType({
    required ColorBlindnessType? simulatedColorBlindnessType,
  }) => setState(
    () => this.simulatedColorBlindnessType = simulatedColorBlindnessType,
  );

  @override
  Widget build(BuildContext context) {
    return _AccessibilityState(
      boldText: boldText,
      textScaleFactor: textScaleFactor,
      semanticMode: semanticMode,
      semanticsScope: semanticsScope,
      showMergedSemanticsNodes: showMergedSemanticsNodes,
      showHiddenSemanticsNodes: showHiddenSemanticsNodes,
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
    required this.semanticsScope,
    required this.showMergedSemanticsNodes,
    required this.showHiddenSemanticsNodes,
    required this.simulatedColorBlindnessType,
    required super.child,
  });

  final double textScaleFactor;
  final bool boldText;
  final SemanticMode semanticMode;
  final SemanticsScope semanticsScope;
  final bool showMergedSemanticsNodes;
  final bool showHiddenSemanticsNodes;
  final ColorBlindnessType? simulatedColorBlindnessType;

  @override
  bool updateShouldNotify(_AccessibilityState oldWidget) {
    return textScaleFactor != oldWidget.textScaleFactor ||
        boldText != oldWidget.boldText ||
        semanticMode != oldWidget.semanticMode ||
        semanticsScope != oldWidget.semanticsScope ||
        showMergedSemanticsNodes != oldWidget.showMergedSemanticsNodes ||
        showHiddenSemanticsNodes != oldWidget.showHiddenSemanticsNodes ||
        simulatedColorBlindnessType != oldWidget.simulatedColorBlindnessType;
  }
}

enum SemanticMode {
  none,
  overlay,
  inspection,
}

enum SemanticsScope {
  useCase,
  app,
}
