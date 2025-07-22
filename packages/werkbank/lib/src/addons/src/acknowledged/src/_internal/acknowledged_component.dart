import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_manager.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class AcknowledgedComponent extends StatefulWidget {
  const AcknowledgedComponent({this.maxCount = 10, super.key});

  final int maxCount;

  @override
  State<AcknowledgedComponent> createState() => _AcknowledgedComponentState();
}

class _AcknowledgedComponentState extends State<AcknowledgedComponent> {
  List<(AcknowledgedDescriptorEntry, Descriptor)>? records;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newEntries = AcknowledgedManager.useCaseEntriesOf(context);
    final pageTransitionDuration = PageTransitionOptions.durationOf(context);
    final newEntriesCapped = newEntries.sublist(
      0,
      min(
        widget.maxCount,
        newEntries.length,
      ),
    );

    final onInit = records == null;
    if (onInit) {
      _update(newEntriesCapped);
    } else {
      // To prevent the UI
      // from flickering while changing the page.
      unawaited(
        Future<void>.delayed(pageTransitionDuration).then((_) {
          if (mounted) {
            _update(newEntriesCapped);
          }
        }),
      );
    }
  }

  void _update(List<AcknowledgedDescriptorEntry> newEntries) {
    final root = HomePageComponent.access.rootDescriptorOf(context);
    final newRecords = newEntries.map((e) {
      return (e, root.maybeFromPath(e.path)!);
    }).toList();
    setState(() {
      records = newRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final record in records!)
          Builder(
            builder: (context) {
              final entry = record.$1;
              final descriptor = record.$2;
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
                    child: Row(
                      children: [
                        if (!entry.acknowledged)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            // TODO(lwiedekamp): This could look way better
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.werkbankColorScheme.logo,
                                border: Border.all(
                                  color: context
                                      .werkbankColorScheme
                                      .backgroundActive,
                                ),
                              ),
                            ),
                          ),
                        Flexible(
                          child: WPathDisplay(
                            nameSegments: descriptor.nameSegments,
                          ),
                        ),
                      ],
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
