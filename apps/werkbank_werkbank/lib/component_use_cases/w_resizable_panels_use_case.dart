import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wResizablePanelsUseCase(UseCaseComposer c) {
  c.constraints.supported(
    const BoxConstraints(minWidth: 420),
  );
  return (context) {
    return const PanelControllerProvider(
      child: WResizablePanels(
        leftPanel: SizedBox.expand(),
        rightPanel: SizedBox.expand(),
        child: SizedBox.expand(),
      ),
    );
  };
}
