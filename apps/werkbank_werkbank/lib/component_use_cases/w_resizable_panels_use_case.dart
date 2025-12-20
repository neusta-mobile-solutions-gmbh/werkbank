import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wResizablePanelsUseCase(UseCaseComposer c) {
  c.constraints.supported(
    const BoxConstraints(minWidth: 420),
  );

  final controllerContainer = c.states.mutable(
    'WPanelController',
    create: () => WPanelController(
      initialLeftWidth: 500,
      initialRightWidth: 500,
    ),
    dispose: (controller) => controller.dispose(),
  );

  return (context) {
    return WResizablePanels(
      controller: controllerContainer.value,
      leftPanel: const SizedBox.expand(),
      rightPanel: const SizedBox.expand(),
      child: const SizedBox.expand(),
    );
  };
}
