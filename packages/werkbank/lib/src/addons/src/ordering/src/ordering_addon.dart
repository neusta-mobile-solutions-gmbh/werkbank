/// @docImport 'package:werkbank/src/addon_config/addon_config.dart';
library;

import 'package:material_ui/material_ui.dart';
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
  const OrderingAddon() : _fixedOrder = null, super(id: addonId);

  /// Creates an [OrderingAddon] that always uses the given [order].
  ///
  /// No control to change the ordering is shown in the settings tab.
  const OrderingAddon.fixed({required OrderOption order})
    : _fixedOrder = order,
      super(id: addonId);

  static const addonId = 'ordering';

  final OrderOption? _fixedOrder;

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'ordering_manager',
          appOnly: true,
          builder: (context, child) => OrderingManager(
            fixedOrder: _fixedOrder,
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
    if (_fixedOrder != null) {
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
