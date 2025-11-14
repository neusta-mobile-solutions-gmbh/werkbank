import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_controller.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/tree/tree.dart';

class AcknowledgedComponent extends StatefulWidget {
  const AcknowledgedComponent({this.maxCount = 10, super.key});

  final int maxCount;

  @override
  State<AcknowledgedComponent> createState() => _AcknowledgedComponentState();
}

class _AcknowledgedComponentState extends State<AcknowledgedComponent> {
  late List<UseCaseDescriptor> descriptors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rootDescriptor = HomePageComponent.access.rootDescriptorOf(context);
    // We don't want to listen to changes here.
    // Doing so would cause the list to immediately update when the user
    // navigates to a use case, even though we are transitioning away
    // from the home page. This would look janky.
    descriptors = HomePageComponent.access
        .globalStateControllerOf<AcknowledgedController>(context)
        .getNewUseCases(rootDescriptor);
  }

  @override
  Widget build(BuildContext context) {
    if (descriptors.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          context.sL10n.addons.acknowledged.noNewUseCases,
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
                child: Row(
                  children: [
                    Expanded(
                      child: WPathDisplay(
                        nameSegments: descriptor.nameSegments,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        size: 24,
                        WerkbankIcons.plusCircle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
