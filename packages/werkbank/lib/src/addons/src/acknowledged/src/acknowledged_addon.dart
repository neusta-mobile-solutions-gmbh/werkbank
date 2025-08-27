import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_component.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_manager.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
/// This addon just displays the acknowledged state of the app.
/// The state itself is managed by the Werkbank.
class AcknowledgedAddon extends Addon {
  const AcknowledgedAddon() : super(id: addonId);

  static const addonId = 'acknowledged';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      applicationOverlay: [
        ApplicationOverlayLayerEntry(
          id: 'acknowledged_manager',
          builder: (context, child) => AcknowledgedManager(
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    final entries = AcknowledgedManager.useCaseEntriesOf(context);
    return [
      if (entries.isNotEmpty)
        HomePageComponent(
          sortHint: SortHint.beforeMost,
          title: Text(context.sL10n.addons.acknowledged.homePageComponentTitle),
          child: const AcknowledgedComponent(),
        ),
    ];
  }
}
