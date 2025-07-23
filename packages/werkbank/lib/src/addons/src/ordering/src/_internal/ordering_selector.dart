import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/ordering/src/_internal/ordering_manager.dart';
import 'package:werkbank/werkbank_old.dart';

class OrderingSelector extends StatelessWidget {
  const OrderingSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final sL10n = context.sL10n;
    return WControlItem(
      title: Text(sL10n.addons.ordering.controls.order.name),
      control: WDropdown<OrderOption>(
        value: OrderingManager.selectedOrderingOf(context),
        onChanged: (value) {
          OrderingManager.setSelectedOrderingState(
            context,
            order: value,
          );
        },
        items: [
          for (final order in OrderOption.values)
            WDropdownMenuItem(
              value: order,
              child: Text(
                sL10n.orderName(order),
              ),
            ),
        ],
      ),
    );
  }
}

extension on Translations {
  String orderName(OrderOption option) {
    switch (option) {
      case OrderOption.alphabetic:
        return addons.ordering.controls.order.values.alphabetical;
      case OrderOption.code:
        return addons.ordering.controls.order.values.code;
    }
  }
}
