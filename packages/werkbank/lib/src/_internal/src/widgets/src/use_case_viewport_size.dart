import 'package:flutter/material.dart';

class UseCaseViewportSize extends InheritedWidget {
  const UseCaseViewportSize({
    super.key,
    required this.size,
    required super.child,
  });

  final Size size;

  static Size? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UseCaseViewportSize>()?.size;

  @override
  bool updateShouldNotify(UseCaseViewportSize oldWidget) {
    return size != oldWidget.size;
  }
}
