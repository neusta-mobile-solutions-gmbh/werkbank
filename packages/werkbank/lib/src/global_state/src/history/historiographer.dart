import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/routing/routing.dart';

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
    final path = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      DescriptorNavState(:final descriptor) => descriptor.path,
    };
    if (path != null) {
      GlobalStateManager.maybeHistoryOf(context)?.log(
        WerkbankHistoryEntry(
          path: path,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
