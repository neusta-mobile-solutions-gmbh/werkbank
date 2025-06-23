import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/_internal/w_animated_tree_segment.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Werkbank Components}
class WTreeView extends StatelessWidget {
  const WTreeView({
    super.key,
    required this.treeNodes,
  });

  final List<WTreeNode> treeNodes;

  @override
  Widget build(BuildContext context) {
    return _ChildList(
      nodes: treeNodes,
      nestingLevel: 0,
    );
  }
}

class _Tree extends StatelessWidget {
  const _Tree({
    required this.wNode,
    required this.nestingLevel,
  });

  final WTreeNode wNode;
  final int nestingLevel;

  @override
  Widget build(BuildContext context) {
    final children = wNode.children ?? [];
    return WAnimatedTreeSegment(
      node: wNode,
      nestingLevel: nestingLevel,
      child: children.isEmpty
          ? null
          : _ChildList(
              nestingLevel: nestingLevel + 1,
              nodes: children,
            ),
    );
  }
}

class _ChildList extends StatelessWidget {
  const _ChildList({
    required this.nestingLevel,
    required this.nodes,
  });

  final int nestingLevel;
  final List<WTreeNode> nodes;

  @override
  Widget build(BuildContext context) {
    final visibleNodes = nodes.where((node) => node.isVisible).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, node) in visibleNodes.indexed)
          Padding(
            key: node.key,
            padding: EdgeInsets.only(
              top: i == 0 ? 0 : 4,
            ),
            child: _Tree(
              wNode: node,
              nestingLevel: nestingLevel,
            ),
          ),
      ],
    );
  }
}
