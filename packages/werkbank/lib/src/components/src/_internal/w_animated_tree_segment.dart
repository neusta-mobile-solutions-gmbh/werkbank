import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/src/nav_event_provider.dart';
import 'package:werkbank/src/components/components.dart';

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
  State<WAnimatedTreeSegment> createState() => _WAnimatedTreeSegmentState();
}

class _WAnimatedTreeSegmentState extends State<WAnimatedTreeSegment> {
  late bool isExpanded;
  late StreamSubscription<NavigationEvent> _navEventSubscription;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.node.isInitiallyExpanded;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navEventSubscription = NavEventProvider.of(context).listen(_onNavEvent);
  }

  bool _isTarget(List<String> targetPathSegments) {
    final myPathSegments = widget.node.pathSegments;
    return myPathSegments != null &&
        myPathSegments.isNotEmpty &&
        targetPathSegments.isNotEmpty &&
        myPathSegments.length == targetPathSegments.length &&
        List.generate(
          myPathSegments.length,
          (index) => myPathSegments[index] == targetPathSegments[index],
        ).every((element) => element);
  }

  bool _isPartOfTarget(List<String> targetPathSegments) {
    final myPathSegments = widget.node.pathSegments;
    return myPathSegments != null &&
        myPathSegments.isNotEmpty &&
        targetPathSegments.isNotEmpty &&
        myPathSegments.length <= targetPathSegments.length &&
        List.generate(
          myPathSegments.length,
          (index) => myPathSegments[index] == targetPathSegments[index],
        ).every((element) => element);
  }

  void _onNavEvent(NavigationEvent event) {
    final targetPathSegments = event.pathSegments;

    final isTarget = _isTarget(targetPathSegments);

    if (isTarget) {
      if (!isExpanded) {
        setState(() {
          isExpanded = true;
        });
      }

      unawaited(
        Future<void>.delayed(
          // Before maybe scrolling, we wait
          // a bit to ensure the expansion animation
          // to this node is done.
          Durations.short2,
        ).then(
          (_) {
            final context = this.context;
            if (!context.mounted) {
              return;
            }
            unawaited(
              Scrollable.ensureVisible(
                context,
                duration: Durations.medium2,
              ),
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
    unawaited(_navEventSubscription.cancel());
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
