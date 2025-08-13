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

class SemanticsInspectorTree extends StatelessWidget {
  const SemanticsInspectorTree({super.key, required this.subscription});

  final SemanticsMonitoringSubscription subscription;

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
        ],
      ),
    );
  }

  WTreeNode _buildTreeNode(
    WerkbankTheme theme,
    SemanticsNodeSnapshot node,
    int? activeNodeId,
    SemanticsInspectorController controller,
  ) {
    final isSelected = node.id == activeNodeId;
    return WTreeNode(
      key: ValueKey(node.id),
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
          _buildTreeNode(theme, child, activeNodeId, controller),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.werkbankTheme;
    final semanticsInspectorController = InspectControlSection.access
        .compositionOf(context)
        .accessibility
        .semanticsInspectorController;
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
                  valueListenable: subscription.nodes,
                  builder: (context, nodes, child) {
                    return WTreeView(
                      treeNodes: [
                        for (final node
                            in nodes ??
                                const Iterable<SemanticsNodeSnapshot>.empty())
                          _buildTreeNode(
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
