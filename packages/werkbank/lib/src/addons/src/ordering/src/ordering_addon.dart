import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_manager.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_selector.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
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
