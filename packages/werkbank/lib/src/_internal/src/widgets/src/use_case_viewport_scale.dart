import 'package:flutter/material.dart';

/// An inherited widget that tells the viewport at which scale it is displayed.
/// This will influence how much the [UseCaseViewport.sizePadding] is
/// scaled before it is use to deflate the size which is provided by
/// the [UseCaseViewportSize].
class UseCaseViewportScale extends InheritedWidget {
  const UseCaseViewportScale({
    super.key,
    required this.scale,
    required super.child,
  });

  final double scale;

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<UseCaseViewportScale>()
          ?.scale ??
      1;

  @override
  bool updateShouldNotify(UseCaseViewportScale oldWidget) {
    return scale != oldWidget.scale;
  }
}
