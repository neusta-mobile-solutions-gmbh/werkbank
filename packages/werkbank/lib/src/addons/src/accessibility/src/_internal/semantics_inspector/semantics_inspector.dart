import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantic_mode_control.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_inspector_node_info.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_tree.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/werkbank.dart';

class SemanticsInspector extends StatelessWidget {
  const SemanticsInspector({super.key});

  static Color colorForSemanticsNodeId(int id) {
    final rainbow = Colors.primaries.sublist(0, Colors.primaries.length - 2);
    // This maximizes the color difference with close ids.
    const goldenRatioConjugate = 0.618033988749895;
    return rainbow[(id * goldenRatioConjugate * rainbow.length).floor() %
        rainbow.length];
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SemanticModeControl(),
        _SemanticsInspectorPanel(),
      ],
    );
  }
}

class _SemanticsInspectorPanel extends StatelessWidget {
  const _SemanticsInspectorPanel();

  @override
  Widget build(BuildContext context) {
    final semanticsMode = AccessibilityManager.semanticModeOf(context);
    final isActive = switch (semanticsMode) {
      SemanticMode.none => false,
      SemanticMode.overlay || SemanticMode.inspection => true,
    };
    return WAnimatedVisibility(
      visible: isActive,
      disposeInvisible: true,
      padding: const EdgeInsets.only(top: 16),
      child: _SemanticsInspectorPanelContent(
        controller: InfoControlSection.access
            .compositionOf(context)
            .accessibility
            .semanticsInspectorController
            .semanticsMonitorController,
      ),
    );
  }
}

class _SemanticsInspectorPanelContent extends StatefulWidget {
  const _SemanticsInspectorPanelContent({required this.controller});

  final SemanticsMonitorController controller;

  @override
  State<_SemanticsInspectorPanelContent> createState() =>
      _SemanticsInspectorPanelContentState();
}

class _SemanticsInspectorPanelContentState
    extends State<_SemanticsInspectorPanelContent> {
  late SemanticsMonitoringSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.controller.subscribe();
  }

  @override
  void didUpdateWidget(_SemanticsInspectorPanelContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      subscription.cancel();
      subscription = widget.controller.subscribe();
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SemanticsInspectorTree(
          subscription: subscription,
        ),
        const SizedBox(height: 16),
        SemanticsInspectorNodeInfo(subscription: subscription),
      ],
    );
  }
}
