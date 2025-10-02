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
  late StreamSubscription<List<LocalKey>>? _sub;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.node.isInitiallyExpanded;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sub = HighlightEventProvider.maybeOf(
      context,
    )?.listen(_onHighlightEvent);
  }

  bool _isTarget(List<LocalKey> targetPathSegments) {
    final nodePath = widget.nodePath;
    return nodePath.isNotEmpty &&
        targetPathSegments.isNotEmpty &&
        nodePath.length == targetPathSegments.length &&
        List.generate(
          nodePath.length,
          (index) => nodePath[index] == targetPathSegments[index],
        ).every((element) => element);
  }

  bool _isPartOfTarget(List<LocalKey> targetPathSegments) {
    final nodePath = widget.nodePath;
    return nodePath.isNotEmpty &&
        targetPathSegments.isNotEmpty &&
        nodePath.length <= targetPathSegments.length &&
        List.generate(
          nodePath.length,
          (index) => nodePath[index] == targetPathSegments[index],
        ).every((element) => element);
  }

  void _onHighlightEvent(List<LocalKey> targetPathSegments) {
    final isTarget = _isTarget(targetPathSegments);

    if (isTarget) {
      unawaited(
        Future<void>.delayed(
          // Before maybe scrolling, we wait
          // a bit to ensure the expansion animation
          // to this node is done.
          Durations.medium2,
        ).then(
          (_) async {
            final context = this.context;
            if (!context.mounted) {
              return;
            }

            await Scrollable.ensureVisible(
              context,
              duration: Durations.medium2,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
            );

            if (!context.mounted) {
              return;
            }

            await Scrollable.ensureVisible(
              context,
              duration: Durations.medium2,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            );
          },
        ),
      );

      return;
    }

    final isPartOfTarget = _isPartOfTarget(targetPathSegments);

    if (isPartOfTarget && !isExpanded) {
      setState(() {
        isExpanded = true;
      });
      return;
    }
  }

  @override
  Future<void> dispose() async {
    unawaited(_sub?.cancel());
    super.dispose();
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
          isExpanded: isExpanded,
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
