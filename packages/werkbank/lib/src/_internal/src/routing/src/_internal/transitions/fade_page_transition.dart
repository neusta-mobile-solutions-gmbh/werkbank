import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// Copy of [FadeThroughTransition] from the animations package
/// but without FadeOut and ScaleTransition

class FadePageTransition extends StatelessWidget {
  const FadePageTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    this.fillColor,
    this.child,
  });

  final Animation<double> animation;

  final Animation<double> secondaryAnimation;
  final Color? fillColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _FadeIn(
      animation: animation,
      child: ColoredBox(
        color: fillColor ?? Theme.of(context).canvasColor,
        child: child,
      ),
    );
  }
}

class _FadeIn extends StatelessWidget {
  const _FadeIn({
    this.child,
    required this.animation,
  });

  final Widget? child;
  final Animation<double> animation;

  static final CurveTween _inCurve = CurveTween(
    curve: const Cubic(0, 0, 0.2, 1),
  );
  static final TweenSequence<double> _fadeInOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0),
        weight: 6 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 1).chain(_inCurve),
        weight: 14 / 20,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInOpacity.animate(animation),
      child: child,
    );
  }
}
