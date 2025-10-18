import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/tree/tree.dart';

class RecentHistoryComponent extends StatefulWidget {
  const RecentHistoryComponent({this.maxCount = 8, super.key});

  final int maxCount;

  @override
  State<RecentHistoryComponent> createState() => _RecentHistoryComponentState();
}

class _RecentHistoryComponentState extends State<RecentHistoryComponent> {
  late List<Descriptor> descriptors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rootDescriptor = HomePageComponent.access.rootDescriptorOf(context);
    // We don't want to listen to changes in the history here.
    // Doing so would cause the list to immediately update when the user
    // navigates to a use case, even though we are transitioning away
    // from the home page. This would look janky.
    descriptors = HomePageComponent.access
        .historyOf(context)
        .getRecentlyVisitedDescriptors(rootDescriptor)
        .map((r) => r.$1)
        .where(
          (descriptor) => switch (descriptor) {
            ParentDescriptor() => false,
            UseCaseDescriptor() => true,
          },
        )
        .take(widget.maxCount)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    if (descriptors.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          context.sL10n.addons.recentHistory.noUseCasesVisited,
          style: context.werkbankTextTheme.defaultText,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          for (final descriptor in descriptors)
            WButtonBase(
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
        ],
      ),
    );
  }
}
