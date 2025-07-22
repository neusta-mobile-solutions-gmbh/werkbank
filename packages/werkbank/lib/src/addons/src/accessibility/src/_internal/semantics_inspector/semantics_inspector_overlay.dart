import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/ignore_pointer_with_semantics.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_box_display.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_controller.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_nodes_display.dart';
import 'package:werkbank/werkbank.dart';

class SemanticsInspectorOverlay extends StatefulWidget {
  const SemanticsInspectorOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SemanticsInspectorOverlay> createState() =>
      _SemanticsInspectorOverlayState();
}

class _SemanticsInspectorOverlayState extends State<SemanticsInspectorOverlay> {
  late SemanticsInspectorController inspectorController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inspectorController = UseCaseOverlayLayerEntry.access
        .compositionOf(context)
        .accessibility
        .semanticsInspectorController;
  }

  List<int> _pressedIdStack = [];
  List<int> _previousPressedIdStack = [];

  void _setActiveId() {
    if (_pressedIdStack.isEmpty) {
      inspectorController.setActiveSemanticsNodeId(null);
      return;
    }
    final activeId = inspectorController.activeSemanticsNodeId.value;
    if (activeId == null) {
      inspectorController.setActiveSemanticsNodeId(_pressedIdStack.first);
      return;
    }
    int? nextIndex;
    var i = 0;
    for (final id in _pressedIdStack) {
      if (i >= _previousPressedIdStack.length ||
          id != _previousPressedIdStack[i]) {
        break;
      }
      if (id == activeId) {
        nextIndex = i + 1;
        break;
      }
      i++;
    }
    if (nextIndex == null) {
      inspectorController.setActiveSemanticsNodeId(_pressedIdStack.first);
      return;
    }
    if (nextIndex < _pressedIdStack.length) {
      inspectorController.setActiveSemanticsNodeId(_pressedIdStack[nextIndex]);
    }
  }

  void _handleTap() {
    _setActiveId();
    _previousPressedIdStack = _pressedIdStack;
    _pressedIdStack = [];
  }

  @override
  Widget build(BuildContext context) {
    final semanticMode = AccessibilityManager.semanticModeOf(context);
    final showSemantics = switch (semanticMode) {
      SemanticMode.none => false,
      SemanticMode.overlay || SemanticMode.inspection => true,
    };
    final isInspectionMode = switch (semanticMode) {
      SemanticMode.none || SemanticMode.overlay => false,
      SemanticMode.inspection => true,
    };
    final controller = inspectorController.semanticsMonitorController;
    return Stack(
      children: [
        SemanticsMonitor(
          controller: controller,
          onlyListenToIncluded: true,
          child: IgnorePointerWithSemantics(
            ignoring: isInspectionMode,
            child: widget.child,
          ),
        ),
        if (showSemantics)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !isInspectionMode,
              child: Listener(
                onPointerDown: (e) {
                  if (e.buttons != kPrimaryButton) {
                    return;
                  }
                  _handleTap();
                },
                behavior: HitTestBehavior.opaque,
                child: SemanticsNodesDisplay(
                  controller: controller,
                  semanticsBoxBuilder: (context, data) {
                    return SemanticsBoxDisplay(
                      displayData: data,
                      onTap: () {
                        _pressedIdStack.add(data.id);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
