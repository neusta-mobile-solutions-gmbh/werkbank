import 'package:flutter/material.dart';
import 'package:werkbank/src/environment/environment.dart';

class WerkbankEnvironmentProvider extends InheritedWidget {
  const WerkbankEnvironmentProvider({
    super.key,
    required this.environment,
    required super.child,
  });

  final WerkbankEnvironment environment;

  static WerkbankEnvironment of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<WerkbankEnvironmentProvider>()!
        .environment;
  }

  @override
  bool updateShouldNotify(WerkbankEnvironmentProvider oldWidget) {
    assert(
      oldWidget.environment == environment,
      'The WerkbankEnvironment must stay constant during '
      'the lifetime of a widget.',
    );
    return oldWidget.environment != environment;
  }
}
