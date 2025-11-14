import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_component.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_controller.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_root_descriptor_tracker.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_visit_tracker.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
/// This addon just displays the acknowledged state of the app.
/// The state itself is managed by the Werkbank.
class AcknowledgedAddon extends Addon {
  const AcknowledgedAddon() : super(id: addonId);

  static const addonId = 'acknowledged';

  @override
  void registerGlobalStateControllers(GlobalStateControllerRegistry registry) {
    registry.register(
      'acknowledged',
      AcknowledgedController.new,
    );
  }

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      // TODO: Move to management layer?
      applicationOverlay: [
        ApplicationOverlayLayerEntry(
          id: 'acknowledged_root_descriptor_tracker',
          builder: (context, child) => AcknowledgedRootDescriptorTracker(
            child: child,
          ),
        ),
        ApplicationOverlayLayerEntry(
          id: 'acknowledged_visit_tracker',
          builder: (context, child) => AcknowledgedVisitTracker(
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    return [
      HomePageComponent(
        sortHint: SortHint.beforeMost,
        title: Text(context.sL10n.addons.acknowledged.homePageComponentTitle),
        child: const AcknowledgedComponent(),
      ),
    ];
  }
}
