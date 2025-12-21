import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/colorblindness_overlay/colorblindness_type.dart';

// TODO: Use GlobalStateController
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

  static SemanticsMode semanticsModeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .semanticsMode;
  }

  static void setSemanticsMode(
    BuildContext context,
    SemanticsMode semanticsMode,
  ) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setSemanticsMode(semanticsMode: semanticsMode);
  }

  static Axis splitAxisOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .splitAxis;
  }

  static void setSplitAxis(BuildContext context, {required Axis splitAxis}) {
    context.findAncestorStateOfType<_AccessibilityManagerState>()!.setSplitAxis(
      splitAxis: splitAxis,
    );
  }

  static SemanticsInspectionScope semanticsInspectionScopeOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<_AccessibilityState>()!
        .semanticsInspectionScope;
  }

  static void setSemanticsInspectionScope(
    BuildContext context,
    SemanticsInspectionScope semanticsInspectionScope,
  ) {
    context
        .findAncestorStateOfType<_AccessibilityManagerState>()!
        .setSemanticsInspectionScope(
          semanticsInspectionScope: semanticsInspectionScope,
        );
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
  SemanticsMode semanticsMode = SemanticsMode.none;
  Axis splitAxis = Axis.vertical;
  SemanticsInspectionScope semanticsInspectionScope =
      SemanticsInspectionScope.useCase;
  bool showMergedSemanticsNodes = false;
  bool showHiddenSemanticsNodes = true;
  ColorBlindnessType? simulatedColorBlindnessType;

  void setTextScaleFactor({required double textScaleFactor}) =>
      setState(() => this.textScaleFactor = textScaleFactor);

  void setBoldText({required bool boldText}) =>
      setState(() => this.boldText = boldText);

  void setSemanticsMode({required SemanticsMode semanticsMode}) =>
      setState(() => this.semanticsMode = semanticsMode);

  void setSplitAxis({required Axis splitAxis}) =>
      setState(() => this.splitAxis = splitAxis);

  void setSemanticsInspectionScope({
    required SemanticsInspectionScope semanticsInspectionScope,
  }) =>
      setState(() => this.semanticsInspectionScope = semanticsInspectionScope);

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
      semanticsMode: semanticsMode,
      splitAxis: splitAxis,
      semanticsInspectionScope: semanticsInspectionScope,
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
    required this.semanticsMode,
    required this.splitAxis,
    required this.semanticsInspectionScope,
    required this.showMergedSemanticsNodes,
    required this.showHiddenSemanticsNodes,
    required this.simulatedColorBlindnessType,
    required super.child,
  });

  final double textScaleFactor;
  final bool boldText;
  final SemanticsMode semanticsMode;
  final Axis splitAxis;
  final SemanticsInspectionScope semanticsInspectionScope;
  final bool showMergedSemanticsNodes;
  final bool showHiddenSemanticsNodes;
  final ColorBlindnessType? simulatedColorBlindnessType;

  @override
  bool updateShouldNotify(_AccessibilityState oldWidget) {
    return textScaleFactor != oldWidget.textScaleFactor ||
        boldText != oldWidget.boldText ||
        semanticsMode != oldWidget.semanticsMode ||
        splitAxis != oldWidget.splitAxis ||
        semanticsInspectionScope != oldWidget.semanticsInspectionScope ||
        showMergedSemanticsNodes != oldWidget.showMergedSemanticsNodes ||
        showHiddenSemanticsNodes != oldWidget.showHiddenSemanticsNodes ||
        simulatedColorBlindnessType != oldWidget.simulatedColorBlindnessType;
  }
}

enum SemanticsMode {
  none,
  overlay,
  inspection,
  sideBySide,
}

enum SemanticsInspectionScope {
  useCase,
  app,
}
