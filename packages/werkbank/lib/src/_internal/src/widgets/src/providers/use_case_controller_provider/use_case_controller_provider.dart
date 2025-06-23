import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class UseCaseControllerProvider extends InheritedWidget {
  const UseCaseControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static UseCaseController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UseCaseControllerProvider>()!
        .controller;
  }

  final UseCaseController controller;

  @override
  bool updateShouldNotify(UseCaseControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
