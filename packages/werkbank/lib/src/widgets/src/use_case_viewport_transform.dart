import 'package:flutter/material.dart';

/// An inherited widget that allows to provide a transform which is applied to
/// the viewport of a use case.
class UseCaseViewportTransform extends StatelessWidget {
  const UseCaseViewportTransform({
    super.key,
    required this.transform,
    required this.child,
  }) : overwrite = false;

  const UseCaseViewportTransform.overwrite({
    super.key,
    required this.transform,
    required this.child,
  }) : overwrite = true;

  static Matrix4 of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<
              _InheritedUseCaseViewportTransform
            >()
            ?.transform ??
        Matrix4.identity();
  }

  final Matrix4 transform;
  final bool overwrite;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var transform = this.transform;
    if (!overwrite) {
      final inheritedTransform = of(context);
      transform = inheritedTransform.multiplied(transform);
    }
    return _InheritedUseCaseViewportTransform(
      transform: transform,
      child: child,
    );
  }
}

class _InheritedUseCaseViewportTransform extends InheritedWidget {
  const _InheritedUseCaseViewportTransform({
    required this.transform,
    required super.child,
  });

  final Matrix4 transform;

  @override
  bool updateShouldNotify(_InheritedUseCaseViewportTransform oldWidget) {
    return oldWidget.transform != transform;
  }
}
