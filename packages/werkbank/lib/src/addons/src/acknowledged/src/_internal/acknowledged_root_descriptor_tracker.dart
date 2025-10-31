import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/acknowledged/src/_internal/acknowledged_controller.dart';

class AcknowledgedRootDescriptorTracker extends StatefulWidget {
  const AcknowledgedRootDescriptorTracker({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<AcknowledgedRootDescriptorTracker> createState() =>
      _AcknowledgedRootDescriptorTrackerState();
}

class _AcknowledgedRootDescriptorTrackerState
    extends State<AcknowledgedRootDescriptorTracker> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final acknowledgedController = ApplicationOverlayLayerEntry.access
        .globalStateControllerOf<AcknowledgedController>(context);
    final rootDescriptor = ApplicationOverlayLayerEntry.access.rootDescriptorOf(
      context,
    );
    acknowledgedController.logRootDescriptorChange(rootDescriptor);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
