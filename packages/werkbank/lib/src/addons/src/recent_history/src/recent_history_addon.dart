import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/recent_history/src/_internal/recent_history_component.dart';
import 'package:werkbank/src/addons/src/recent_history/src/_internal/recent_history_manager.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
/// This addon just displays the history of the app.
/// The state itself is managed by the Werkbank.
class RecentHistoryAddon extends Addon {
  const RecentHistoryAddon() : super(id: addonId);

  static const addonId = 'recent_history';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      applicationOverlay: [
        ApplicationOverlayLayerEntry(
          id: 'recent_history_manager',
          builder: (context, child) => RecentHistoryManager(
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    final recentHistory = RecentHistoryManager.recentHistoryOf(context);
    return [
      if (recentHistory.isNotEmpty)
        HomePageComponent(
          sortHint: const SortHint(-1100),
          title: Text(
            context.sL10n.addons.recentHistory.homePageComponentTitle,
          ),
          child: const RecentHistoryComponent(),
        ),
    ];
  }
}
