import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class UseCaseEnvironmentProvider extends InheritedWidget {
  const UseCaseEnvironmentProvider({
    super.key,
    required this.environment,
    required super.child,
  });

  final UseCaseEnvironment environment;

  static UseCaseEnvironment of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UseCaseEnvironmentProvider>()!
        .environment;
  }

  static UseCaseEnvironment? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UseCaseEnvironmentProvider>()
        ?.environment;
  }

  @override
  bool updateShouldNotify(UseCaseEnvironmentProvider oldWidget) {
    return oldWidget.environment != environment;
  }
}
