import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/persistence/src/werkbank_persistence.dart';
import 'package:werkbank/src/routing/routing.dart';

class AcknowledgedTracker extends StatefulWidget {
  const AcknowledgedTracker({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AcknowledgedTracker> createState() => _AcknowledgedTrackerState();
}

class _AcknowledgedTrackerState extends State<AcknowledgedTracker> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final path = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      DescriptorNavState(:final descriptor) => descriptor.path,
    };
    if (path != null) {
      WerkbankPersistence.maybeAcknowledgedController(context)?.log(
        path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
