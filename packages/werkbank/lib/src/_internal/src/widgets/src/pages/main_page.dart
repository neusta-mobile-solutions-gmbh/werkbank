import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/routing/src/nav_event_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/_internal/page_background.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/notifications/notifications.dart';
import 'package:werkbank/src/persistence/persistence.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.mainView,
  });

  final Widget mainView;

  @override
  Widget build(BuildContext context) {
    return NavStateProvider(
      child: NavEventProvider(
        child: Historiographer(
          child: WerkbankShortcuts(
            child: WasAliveTracker(
              child: AcknowledgedTracker(
                child: Scaffold(
                  backgroundColor: PageBackground.colorOf(context),
                  body: AddonLayerBuilder(
                    layer: AddonLayer.applicationOverlay,
                    child: UseCaseControllerManager(
                      child: WResizablePanels(
                        leftPanel: const NavigationPanel(),
                        rightPanel: const ConfigurationPanel(),
                        child: WerkbankNotificationsDisplay(
                          child: AddonLayerBuilder(
                            layer: AddonLayer.mainViewOverlay,
                            child: mainView,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
