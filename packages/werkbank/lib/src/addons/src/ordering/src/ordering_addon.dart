import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_manager.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_selector.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
/// An [Addon] that enables control over the ordering of the [WerkbankNode]
/// tree structure in the navigation panel.
///
/// Note: This addon is not included by default in [AddonConfig].
/// You can add it manually to your addon list if needed.
/// It is mainly provided as an example of how to control
/// the ordering of nodes via an Addon.
class OrderingAddon extends Addon {
  const OrderingAddon() : super(id: addonId);

  static const addonId = 'ordering';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'ordering_manager',
          appOnly: true,
          builder: (context, child) => OrderingManager(
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    return [
      const SettingsControlSection(
        id: 'ordering',
        title: Text('Ordering'),
        sortHint: SortHint.afterMost,
        children: [
          OrderingSelector(),
        ],
      ),
    ];
  }
}
