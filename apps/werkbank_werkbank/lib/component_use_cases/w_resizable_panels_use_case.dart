import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wResizablePanelsUseCase(UseCaseComposer c) {
  c.constraints.supported(
    const BoxConstraints(minWidth: 420),
  );

  final controllerContainer = c.states.mutableWithTickerProvider(
    'WPanelController',
    create: (tickerProvider) => WPanelController(
      vsync: tickerProvider,
      // TODO: Remove Parameter?
      initialMaxWidth: double.infinity,
      initialWidth: 500,
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
