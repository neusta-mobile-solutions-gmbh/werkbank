import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/components/src/w_tree_view/_internal/highlight_event_provider.dart';
import 'package:werkbank/src/components/src/w_tree_view/_internal/w_animated_tree_segment.dart';

/// {@category Werkbank Components}
class WTreeView extends StatefulWidget {
  WTreeView({
    super.key,
    required this.treeNodes,
    this.highlightStream,
  }) : assert(
         highlightStream?.isBroadcast ?? true,
         'highlightStream must be a broadcast stream',
       );

  final List<WTreeNode> treeNodes;
  final Stream<LocalKey>? highlightStream;

  @override
  State<WTreeView> createState() => _WTreeViewState();
}

class _WTreeViewState extends State<WTreeView> {
  late Map<LocalKey, List<LocalKey>> _keyToPath;

  @override
  void initState() {
    super.initState();
    _updateKeyToPath();
  }

  @override
  void didUpdateWidget(WTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.treeNodes != widget.treeNodes) {
      _updateKeyToPath();
    }
  }

  void _updateKeyToPath() {
    _keyToPath = {};
    void traverse(WTreeNode node, List<LocalKey> path) {
      if (_keyToPath.containsKey(node.key)) {
        throw ArgumentError(
          'Duplicate key found in tree: ${node.key}',
        );
      }
      _keyToPath[node.key] = path;
      for (final child in node.children ?? const Iterable<WTreeNode>.empty()) {
        traverse(child, [...path, child.key]);
      }
    }

    for (final node in widget.treeNodes) {
      traverse(node, [node.key]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HighlightEventProvider(
      highlightStream: widget.highlightStream?.map(
        (key) =>
            _keyToPath[key] ??
            (throw ArgumentError(
              'Key $key not found in tree',
            )),
      ),
      child: _Children(
        nodes: widget.treeNodes,
        path: const [],
        nestingLevel: 0,
      ),
    );
  }
}

class _Tree extends StatelessWidget {
  const _Tree({
    required this.node,
    required this.path,
    required this.nestingLevel,
  });

  final WTreeNode node;
  final List<LocalKey> path;
  final int nestingLevel;

  @override
  Widget build(BuildContext context) {
    final children = node.children ?? [];
    return WAnimatedTreeSegment(
      node: node,
      nodePath: path,
      nestingLevel: nestingLevel,
      child: children.isEmpty
          ? null
          : _Children(
              nestingLevel: nestingLevel + 1,
              nodes: children,
              path: path,
            ),
    );
  }
}

class _Children extends StatelessWidget {
  const _Children({
    required this.nestingLevel,
    required this.nodes,
    required this.path,
  });

  final int nestingLevel;
  final List<WTreeNode> nodes;
  final List<LocalKey> path;

  @override
  Widget build(BuildContext context) {
    final visibleNodes = nodes
        .where((node) => node.isVisible)
        .toList(growable: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, node) in visibleNodes.indexed)
          Padding(
            key: node.key,
            padding: EdgeInsets.only(
              top: i == 0 ? 0 : 2,
            ),
            child: _Tree(
              node: node,
              path: [...path, node.key],
              nestingLevel: nestingLevel,
            ),
          ),
      ],
    );
  }
}
