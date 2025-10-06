import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/components/src/_internal/w_animated_tree_segment.dart';
import 'package:werkbank/src/components/src/w_tree_view/_internal/highlight_event_provider.dart';

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
        nodesAndTheirPath: widget.treeNodes
            .map((node) => (node, [node.key]))
            .toList(),
        nestingLevel: 0,
      ),
    );
  }
}

class _Tree extends StatelessWidget {
  const _Tree({
    required this.nodeAndItsPath,
    required this.nestingLevel,
  });

  final (WTreeNode, List<LocalKey>) nodeAndItsPath;
  final int nestingLevel;

  @override
  Widget build(BuildContext context) {
    final children = nodeAndItsPath.$1.children ?? [];
    return WAnimatedTreeSegment(
      node: nodeAndItsPath.$1,
      nodePath: nodeAndItsPath.$2,
      nestingLevel: nestingLevel,
      child: children.isEmpty
          ? null
          : _Children(
              nestingLevel: nestingLevel + 1,
              nodesAndTheirPath: children.map((child) {
                final childPath = [...nodeAndItsPath.$2, child.key];
                return (child, childPath);
              }).toList(),
            ),
    );
  }
}

class _Children extends StatelessWidget {
  const _Children({
    required this.nestingLevel,
    required this.nodesAndTheirPath,
  });

  final int nestingLevel;
  final List<(WTreeNode, List<LocalKey>)> nodesAndTheirPath;

  @override
  Widget build(BuildContext context) {
    final visibleNodes = nodesAndTheirPath
        .where((node) => node.$1.isVisible)
        .toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, node) in visibleNodes.indexed)
          Padding(
            key: node.$1.key,
            padding: EdgeInsets.only(
              top: i == 0 ? 0 : 2,
            ),
            child: _Tree(
              nodeAndItsPath: node,
              nestingLevel: nestingLevel,
            ),
          ),
      ],
    );
  }
}
