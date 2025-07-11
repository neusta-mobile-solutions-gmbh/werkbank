import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

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
      WerkbankPersistence.maybeHistoryOf(context)?.log(
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
