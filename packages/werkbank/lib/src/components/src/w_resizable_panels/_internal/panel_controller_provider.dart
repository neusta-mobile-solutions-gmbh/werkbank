import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';

class WPanelControllerProvider extends InheritedWidget {
  const WPanelControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static WPanelController of(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<WPanelControllerProvider>()!
        .controller;
  }

  final WPanelController controller;

  @override
  bool updateShouldNotify(WPanelControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
