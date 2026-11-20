/// @docImport 'package:werkbank/src/addon_config/addon_config.dart';
library;

import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_manager.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_selector.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/utils/utils.dart';
import 'package:werkbank/src/widgets/widgets.dart';

/// {@category Configuring Addons}
/// An [Addon] that enables control over the ordering of the [WerkbankNode]
/// tree structure in the navigation panel.
///
/// Note: This addon is not included by default in [AddonConfig].
/// You can add it manually to your addon list if needed.
/// It is mainly provided as an example of how to control
/// the ordering of nodes via an Addon.
class OrderingAddon extends Addon {
  const OrderingAddon({
    this.initialOrder = OrderOption.alphabetic,
    this.showControl = true,
  }) : super(id: addonId);

  static const addonId = 'ordering';

  /// Defines the initially selected [OrderOption].
  final OrderOption initialOrder;

  /// Whether to show the control to change the order in the settings tab.
  ///
  /// If you set this to `false`, the [initialOrder] will effectively be only
  /// available order.
  final bool showControl;

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'ordering_manager',
          appOnly: true,
          builder: (context, child) => OrderingManager(
            initialOrder: initialOrder,
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
    if (!showControl) {
      return super.buildSettingsTabControlSections(context);
    }
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
