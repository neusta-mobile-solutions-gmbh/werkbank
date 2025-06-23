import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class WerkbankPage<R> extends Page<R> {
  const WerkbankPage({
    required super.key,
    this.transitionDuration,
    this.transitionBuilder,
    required this.child,
  });

  /// Using this, you can override the Duration provided by the
  /// [PageTransitionOptions] in the context.
  final Duration? transitionDuration;

  /// Using this, you can override the TransitionBuilder provided by the
  /// [PageTransitionOptions] in the context.
  final PageTransitionBuilder? transitionBuilder;

  final Widget child;

  @override
  Route<R> createRoute(BuildContext context) {
    final effectiveTransitionDuration =
        transitionDuration ?? PageTransitionOptions.durationOf(context);
    final effectiveTransitionBuilder =
        transitionBuilder ?? PageTransitionOptions.pageTransitionOf(context);

    return PageRouteBuilder<R>(
      settings: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const backgroundColor = Colors.transparent;
        return effectiveTransitionBuilder(
          context,
          animation,
          secondaryAnimation,
          backgroundColor,
          child,
        );
      },
      transitionDuration: effectiveTransitionDuration,
      reverseTransitionDuration: effectiveTransitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return PageTransitions(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}
