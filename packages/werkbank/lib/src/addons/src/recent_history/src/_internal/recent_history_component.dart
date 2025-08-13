import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/recent_history/src/_internal/recent_history_manager.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/persistence/persistence.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/tree/tree.dart';

class RecentHistoryComponent extends StatefulWidget {
  const RecentHistoryComponent({this.maxCount = 10, super.key});

  final int maxCount;

  @override
  State<RecentHistoryComponent> createState() => _RecentHistoryComponentState();
}

class _RecentHistoryComponentState extends State<RecentHistoryComponent> {
  List<WerkbankHistoryEntry>? recentHistory;
  List<Descriptor> descriptors = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fullRecentHistory = RecentHistoryManager.recentHistoryOf(context);
    final pageTransitionDuration = PageTransitionOptions.durationOf(context);
    final newRecentHistory = fullRecentHistory.sublist(
      0,
      min(
        widget.maxCount,
        fullRecentHistory.length,
      ),
    );

    final onInit = recentHistory == null;
    if (onInit) {
      _update(newRecentHistory);
    } else {
      // To prevent the UI
      // from flickering while changing the page.
      unawaited(
        Future<void>.delayed(pageTransitionDuration).then((_) {
          if (mounted) {
            _update(newRecentHistory);
          }
        }),
      );
    }
  }

  void _update(List<WerkbankHistoryEntry> newRecentHistory) {
    final root = HomePageComponent.access.rootDescriptorOf(context);
    final newDescriptors = newRecentHistory.map((e) {
      return root.maybeFromPath(e.path)!;
    }).toList();
    setState(() {
      recentHistory = newRecentHistory;
      descriptors = newDescriptors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final descriptor in descriptors)
          Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: WButtonBase(
                  onPressed: () {
                    HomePageComponent.access
                        .routerOf(context)
                        .goTo(DescriptorNavState.overviewOrView(descriptor));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: WPathDisplay(
                      nameSegments: descriptor.nameSegments,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
