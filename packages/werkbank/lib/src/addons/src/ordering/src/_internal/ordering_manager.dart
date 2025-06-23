import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class OrderingManager extends StatefulWidget {
  const OrderingManager({
    super.key,
    required this.child,
  });

  final Widget child;

  static OrderOption selectedOrderingOf(BuildContext context) {
    return WerkbankSettings.orderOptionOf(context);
  }

  static void setSelectedOrderingState(
    BuildContext context, {
    required OrderOption order,
  }) {
    context
        .findAncestorStateOfType<_OrderingManagerState>()!
        .setSelectedOrderingState(ordering: order);
  }

  @override
  State<OrderingManager> createState() => _OrderingManagerState();
}

class _OrderingManagerState extends State<OrderingManager> {
  late OrderOption selectedOrderingState;

  @override
  void initState() {
    super.initState();
    selectedOrderingState = OrderOption.alphabetic;
  }

  void setSelectedOrderingState({required OrderOption ordering}) {
    setState(() => selectedOrderingState = ordering);
  }

  @override
  Widget build(BuildContext context) {
    return WerkbankSettings(
      orderOption: selectedOrderingState,
      child: widget.child,
    );
  }
}
