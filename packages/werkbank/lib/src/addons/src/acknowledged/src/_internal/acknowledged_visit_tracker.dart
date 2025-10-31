import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_controller.dart';
import 'package:werkbank/src/routing/routing.dart';

class AcknowledgedVisitTracker extends StatefulWidget {
  const AcknowledgedVisitTracker({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AcknowledgedVisitTracker> createState() =>
      _AcknowledgedVisitTrackerState();
}

class _AcknowledgedVisitTrackerState extends State<AcknowledgedVisitTracker> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final acknowledgedController = ApplicationOverlayLayerEntry.access
        .globalStateControllerOf<AcknowledgedController>(context);
    final useCaseDescriptor = switch (ApplicationOverlayLayerEntry.access
        .navStateOf(context)) {
      HomeNavState() || ParentOverviewNavState() => null,
      UseCaseNavState(:final descriptor) => descriptor,
    };
    if (useCaseDescriptor != null) {
      acknowledgedController.logDescriptorVisit(
        useCaseDescriptor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
