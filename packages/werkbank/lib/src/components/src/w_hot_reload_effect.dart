import 'dart:ui';

import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WHotReloadEffect extends StatelessWidget {
  const WHotReloadEffect({
    required this.animation,
    required this.child,
    super.key,
  });

  final Animation<double>? animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveAnimation = animation ?? const AlwaysStoppedAnimation(0);
    // TODO(lwiedekamp): Maybe use a custom shader someday
    // for something very fancy.
    return AnimatedBuilder(
      animation: effectiveAnimation,
      builder: (context, child) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 10 * (1 - effectiveAnimation.value),
            sigmaY: 10 * (1 - effectiveAnimation.value),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
