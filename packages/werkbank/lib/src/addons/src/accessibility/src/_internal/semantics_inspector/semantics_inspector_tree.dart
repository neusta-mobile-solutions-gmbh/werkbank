import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_data_utils.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_controller.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

class SemanticsInspectorTree extends StatefulWidget {
  const SemanticsInspectorTree({super.key, required this.subscription});

  final SemanticsMonitoringSubscription subscription;

  @override
  State<SemanticsInspectorTree> createState() => _SemanticsInspectorTreeState();
}

class _SemanticsInspectorTreeState extends State<SemanticsInspectorTree> {
  final StreamController<ValueKey<int>> _highlightStreamController =
      StreamController.broadcast();
  SemanticsInspectorController? _semanticsInspectorController;
  int? _previousActiveNodeId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final oldSemanticsInspectorController = _semanticsInspectorController;
    final newSemanticsInspectorController = InspectControlSection.access
        .compositionOf(context)
        .accessibility
        .semanticsInspectorController;
    if (newSemanticsInspectorController != oldSemanticsInspectorController) {
      _semanticsInspectorController = newSemanticsInspectorController;
      oldSemanticsInspectorController?.activeSemanticsNodeId.removeListener(
        _onActiveSemanticsNodeIdChanged,
      );
      newSemanticsInspectorController.activeSemanticsNodeId.addListener(
        _onActiveSemanticsNodeIdChanged,
      );
      _onActiveSemanticsNodeIdChanged();
    }
  }

  ValueKey<int> _keyForNodeId(int nodeId) => ValueKey(nodeId);

  void _onActiveSemanticsNodeIdChanged() {
    final nodeId = _semanticsInspectorController?.activeSemanticsNodeId.value;
    if (nodeId != null && nodeId != _previousActiveNodeId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _highlightStreamController.add(_keyForNodeId(nodeId));
      });
    }
    _previousActiveNodeId = nodeId;
  }

  @override
  void dispose() {
    unawaited(_highlightStreamController.close());
    _semanticsInspectorController?.activeSemanticsNodeId.removeListener(
      _onActiveSemanticsNodeIdChanged,
    );
    super.dispose();
  }

  Widget _buildLabel(
    WerkbankTheme theme,
    SemanticsNodeSnapshot node,
    bool isSelected,
  ) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final label = node.data.label;
    const normalStyle = TextStyle(fontWeight: FontWeight.w500);
    final lightStyle = TextStyle(
      color: isSelected ? colorScheme.textActive : colorScheme.textLight,
    );
    final faintStyle = TextStyle(
      color: isSelected
          ? colorScheme.textActive
          // TODO(lzuttermeister): Use theme color
          : colorScheme.textLight.withValues(alpha: 0.5),
      fontWeight: FontWeight.w100,
    );
    final annotations = <String>[
      if (node.isMergedIntoParent) 'merged',
      if (node.data.flagsCollection.isHidden) 'hidden',
    ];
    return Text.rich(
      TextSpan(
        style: textTheme.input.copyWith(
          // TODO(lzuttermeister): Use theme font
          fontSize: 13,
          color: isSelected ? colorScheme.textActive : colorScheme.text,
        ),
        children: [
          if (label.isNotEmpty)
            SemanticsDataUtils.escapeString(
              label,
              normalStyle: normalStyle,
              replacementStyle: lightStyle,
            )
          else
            TextSpan(
              text: '<No Label>',
              style: lightStyle,
            ),
          if (annotations.isNotEmpty)
            TextSpan(
              text: ' (${annotations.join(', ')})',
              style: faintStyle,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.werkbankTheme;
    final semanticsInspectorController = _semanticsInspectorController!;
    final showMergeSemanticsNodes =
        AccessibilityManager.showMergedSemanticsNodesOf(context);

    WTreeNode? buildTreeNode(
      WerkbankTheme theme,
      SemanticsNodeSnapshot node,
      int? activeNodeId,
      SemanticsInspectorController controller,
    ) {
      if (!showMergeSemanticsNodes && node.isMergedIntoParent) {
        return null;
      }
      // We cannot exclude hidden nodes in the tree, because they might have
      // non hidden children.
      // We could move their children up a level, but that would erase
      // information about the tree structure.
      final isSelected = node.id == activeNodeId;
      return WTreeNode(
        key: _keyForNodeId(node.id),
        title: _buildLabel(theme, node, isSelected),
        leading: Icon(
          Icons.rectangle_rounded,
          color: SemanticsInspector.colorForSemanticsNodeId(node.id),
        ),
        onTap: () {
          if (isSelected) {
            controller.setActiveSemanticsNodeId(null);
          } else {
            controller.setActiveSemanticsNodeId(node.id);
          }
        },
        isInitiallyExpanded: true,
        isSelected: isSelected,
        children: [
          for (final child in node.children)
            ?buildTreeNode(theme, child, activeNodeId, controller),
        ],
      );
    }

    return WControlItem(
      title: Text(context.sL10n.addons.accessibility.controls.semanticsTree),
      layout: ControlItemLayout.spacious,
      control: SizedBox(
        height: 300,
        width: double.infinity,
        child: WOutlineBox(
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8).copyWith(right: 24),
            child: ValueListenableBuilder(
              valueListenable:
                  semanticsInspectorController.activeSemanticsNodeId,
              builder: (context, activeNodeId, child) {
                return ValueListenableBuilder(
                  valueListenable: widget.subscription.nodes,
                  builder: (context, nodes, child) {
                    return WTreeView(
                      /* TODO(lzuttermeister): This currently causes
                           the problem that the outer scroll view reacts
                           to the ensureVisible call too.
                           This sometimes causes the tree to be
                           scrolled out of view. */
                      // highlightStream: _highlightStreamController.stream,
                      treeNodes: [
                        for (final node
                            in nodes ??
                                const Iterable<SemanticsNodeSnapshot>.empty())
                          ?buildTreeNode(
                            theme,
                            node,
                            activeNodeId,
                            semanticsInspectorController,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
