import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/ignore_pointer_with_semantics.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_box_display.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_controller.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_nodes_display.dart';
import 'package:werkbank/src/components/src/w_divider.dart';
import 'package:werkbank/src/theme/theme.dart';

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
  final GlobalKey _childKey = GlobalKey();

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
    final semanticsMode = AccessibilityManager.semanticsModeOf(context);
    late final showMergedSemanticsNodes =
        AccessibilityManager.showMergedSemanticsNodesOf(context);
    late final showHiddenSemanticsNodes =
        AccessibilityManager.showHiddenSemanticsNodesOf(context);
    late final controller = inspectorController.semanticsMonitorController;

    late final display = SemanticsNodesDisplay(
      controller: controller,
      includeNodePredicate: (node) {
        if (!showMergedSemanticsNodes && node.isMergedIntoParent) {
          return false;
        }
        if (!showHiddenSemanticsNodes && node.data.flagsCollection.isHidden) {
          return false;
        }
        return true;
      },
      semanticsBoxBuilder: (context, data) {
        return SemanticsBoxDisplay(
          displayData: data,
          onTap: () {
            _pressedIdStack.add(data.id);
          },
        );
      },
    );

    late final interactiveDisplay = Listener(
      onPointerDown: (e) {
        if (e.buttons != kPrimaryButton) {
          return;
        }
        _handleTap();
      },
      behavior: HitTestBehavior.opaque,
      child: display,
    );

    final monitoredChild = SemanticsMonitor(
      key: _childKey,
      controller: controller,
      onlyListenToIncluded: true,
      child: widget.child,
    );

    switch (semanticsMode) {
      case SemanticsMode.none:
        return monitoredChild;
      case SemanticsMode.overlay:
        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            monitoredChild,
            Positioned.fill(
              child: IgnorePointer(
                child: display,
              ),
            ),
          ],
        );
      case SemanticsMode.inspection:
        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            IgnorePointerWithSemantics(
              child: monitoredChild,
            ),
            Positioned.fill(
              child: interactiveDisplay,
            ),
          ],
        );
      case SemanticsMode.sideBySide:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: monitoredChild,
            ),
            const WDivider.vertical(),
            Expanded(
              child: ClipRect(
                child: ColoredBox(
                  color: context.werkbankColorScheme.surface,
                  child: interactiveDisplay,
                ),
              ),
            ),
          ],
        );
    }
  }
}
