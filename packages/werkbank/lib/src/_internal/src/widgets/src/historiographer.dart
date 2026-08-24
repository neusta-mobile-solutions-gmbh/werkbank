import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/werkbank_app_global_state/werkbank_app_global_state.dart';

class Historiographer extends StatefulWidget {
  const Historiographer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<Historiographer> createState() => _HistoriographerState();
}

class _HistoriographerState extends State<Historiographer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final descriptor = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      DescriptorNavState(:final descriptor) => descriptor,
    };
    if (descriptor != null) {
      GlobalStateManager.of(
        context,
      ).werkbankApp.history.logDescriptorVisit(descriptor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
