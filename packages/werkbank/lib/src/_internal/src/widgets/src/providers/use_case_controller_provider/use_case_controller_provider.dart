import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/use_case/use_case.dart';

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
