import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/src/_internal/transitions/fade_page_transition.dart';

/// A widget that allows you to control the page transition and its duration
/// used by the Werkbank routing system.
///
/// Using null, the default transition and duration will be used.
///
/// {@category Writing Your Own Addons}
class PageTransitionOptions extends InheritedWidget {
  const PageTransitionOptions({
    this.pageTransitionDuration,
    this.pageTransitionBuilder,
    required super.child,
    super.key,
  });

  final Duration? pageTransitionDuration;
  final PageTransitionBuilder? pageTransitionBuilder;

  static Duration durationOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<PageTransitionOptions>();
    return inheritedWidget?.pageTransitionDuration ??
        _defaultPageTransitionDuration;
  }

  static PageTransitionBuilder pageTransitionOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<PageTransitionOptions>();
    return inheritedWidget?.pageTransitionBuilder ??
        _defaultPageTransitionBuilder;
  }

  @override
  bool updateShouldNotify(covariant PageTransitionOptions oldWidget) {
    return oldWidget.pageTransitionDuration != pageTransitionDuration ||
        oldWidget.pageTransitionBuilder != pageTransitionBuilder;
  }
}

const _defaultPageTransitionDuration = Duration(milliseconds: 350);

Widget _defaultPageTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Color fillColor,
  Widget child,
) {
  return FadePageTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    fillColor: fillColor,
    child: child,
  );
}

typedef PageTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Color fillColor,
      Widget child,
    );
