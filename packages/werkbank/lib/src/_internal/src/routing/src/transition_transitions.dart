import 'package:flutter/material.dart';

/// A widget that provides the current page transition animations to its
/// descendants.
///
/// Use this inside a page
class PageTransitions extends InheritedWidget {
  const PageTransitions({
    required this.animation,
    required this.secondaryAnimation,
    required super.child,
    super.key,
  });

  static PageTransitions? _maybeOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<PageTransitions>();
    return inheritedWidget;
  }

  static PageTransitions of(BuildContext context) {
    final inheritedWidget = _maybeOf(context);
    if (inheritedWidget == null) {
      throw FlutterError(
        'PageTransitions.of() called with a context '
        'that does not contain a PageTransitions.',
      );
    }
    return inheritedWidget;
  }

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  @override
  bool updateShouldNotify(PageTransitions oldWidget) {
    return oldWidget.animation != animation ||
        oldWidget.secondaryAnimation != secondaryAnimation;
  }
}
