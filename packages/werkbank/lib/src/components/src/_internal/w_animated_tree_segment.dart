import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class WAnimatedTreeSegment extends StatefulWidget {
  const WAnimatedTreeSegment({
    super.key,
    required this.node,
    required this.child,
    required this.nestingLevel,
  });

  final WTreeNode node;
  final Widget? child;
  final int nestingLevel;

  @override
  State<WAnimatedTreeSegment> createState() => _SAnimatedTreeSegmentState();
}

class _SAnimatedTreeSegmentState extends State<WAnimatedTreeSegment> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.node.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.node.body;
    final showContent = body != null || widget.child != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WTreeItem(
          label: widget.node.title,
          nestingLevel: widget.nestingLevel,
          isSelected: widget.node.isSelected,
          onExpansionChanged: showContent
              ? (value) {
                  setState(() {
                    isExpanded = value;
                  });
                }
              : null,
          initExpanded: widget.node.isInitiallyExpanded,
          onTap: widget.node.onTap,
          trailing: widget.node.trailing,
          leading: widget.node.leading,
        ),
        if (showContent)
          WAnimatedVisibility(
            visible: isExpanded,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (body != null)
                  Padding(
                    padding: EdgeInsets.only(
                      left: widget.nestingLevel * 16.0 + 48,
                    ),
                    child: body,
                  ),
                if (widget.child != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: widget.child,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
