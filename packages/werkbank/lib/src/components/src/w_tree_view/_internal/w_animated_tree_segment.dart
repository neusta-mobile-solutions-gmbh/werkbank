import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/components/src/w_tree_view/_internal/highlight_event_provider.dart';

class WAnimatedTreeSegment extends StatefulWidget {
  const WAnimatedTreeSegment({
    super.key,
    required this.node,
    required this.nodePath,
    required this.child,
    required this.nestingLevel,
  });

  final WTreeNode node;
  final List<LocalKey> nodePath;
  final Widget? child;
  final int nestingLevel;

  @override
  State<WAnimatedTreeSegment> createState() => _WAnimatedTreeSegmentState();
}

class _WAnimatedTreeSegmentState extends State<WAnimatedTreeSegment> {
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
        _Highlighter(
          nodePath: widget.nodePath,
          onDescendantHighlighted: () {
            if (!isExpanded) {
              setState(() {
                isExpanded = true;
              });
            }
          },
          child: WTreeItem(
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
            isExpanded: isExpanded,
            onTap: widget.node.onTap,
            trailing: widget.node.trailing,
            leading: widget.node.leading,
          ),
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

class _Highlighter extends StatefulWidget {
  const _Highlighter({
    required this.nodePath,
    required this.onDescendantHighlighted,
    required this.child,
  });

  final List<LocalKey> nodePath;
  final VoidCallback onDescendantHighlighted;
  final Widget child;

  @override
  State<_Highlighter> createState() => _HighlighterState();
}

class _HighlighterState extends State<_Highlighter> {
  StreamSubscription<List<LocalKey>>? _sub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    unawaited(_sub?.cancel());
    _sub = HighlightEventProvider.maybeOf(
      context,
    )?.listen(_onHighlightEvent);
  }

  _TargetPathRelation _getTargetPathRelation(
    List<LocalKey> targetPathSegments,
  ) {
    if (targetPathSegments.length < widget.nodePath.length) {
      return _TargetPathRelation.notRelated;
    }
    for (final (i, segment) in widget.nodePath.indexed) {
      if (targetPathSegments[i] != segment) {
        return _TargetPathRelation.notRelated;
      }
    }
    if (targetPathSegments.length == widget.nodePath.length) {
      return _TargetPathRelation.target;
    }
    return _TargetPathRelation.ancestorOfTarget;
  }

  void _onHighlightEvent(List<LocalKey> targetPathSegments) {
    final relation = _getTargetPathRelation(targetPathSegments);
    switch (relation) {
      case _TargetPathRelation.target:
        unawaited(_scrollToSelf());
      case _TargetPathRelation.ancestorOfTarget:
        widget.onDescendantHighlighted();
      case _TargetPathRelation.notRelated:
        break;
    }
  }

  Future<void> _scrollToSelf() async {
    // Before maybe scrolling, we wait
    // a bit to ensure the expansion animation
    // to this node is done.
    await Future<void>.delayed(Durations.short4);

    if (!mounted) {
      return;
    }
    await Scrollable.ensureVisible(
      context,
      duration: Durations.medium2,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );

    if (!mounted) {
      return;
    }
    await Scrollable.ensureVisible(
      context,
      duration: Durations.medium2,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    );
  }

  @override
  Future<void> dispose() async {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

enum _TargetPathRelation {
  target,
  ancestorOfTarget,
  notRelated,
}
