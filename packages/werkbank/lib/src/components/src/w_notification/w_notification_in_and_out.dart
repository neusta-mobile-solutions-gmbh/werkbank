import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WNotificationInAndOut extends StatefulWidget {
  const WNotificationInAndOut({
    required this.dismissAnimation,
    required this.child,
    super.key,
  });

  final Animation<double> dismissAnimation;
  final Widget child;

  @override
  State<WNotificationInAndOut> createState() => _WNotificationInAndOutState();
}

class _WNotificationInAndOutState extends State<WNotificationInAndOut>
    with TickerProviderStateMixin {
  late final AnimationController primary;

  @override
  void initState() {
    super.initState();
    primary = AnimationController(
      vsync: this,
      duration: Durations.short2,
    )..forward();
  }

  @override
  void dispose() {
    primary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondary = widget.dismissAnimation;
    final reverseSecondary = ReverseAnimation(secondary);
    return FadeTransition(
      opacity: primary,
      child: ScaleTransition(
        scale: Tween<double>(begin: .95, end: 1).animate(primary),
        child: SizeTransition(
          sizeFactor: CurveTween(
            curve: const Interval(0, .5, curve: Curves.easeInToLinear),
          ).animate(reverseSecondary),
          fixedCrossAxisSizeFactor: 1,
          child: FadeTransition(
            opacity: CurveTween(
              curve: const Interval(.5, 1),
            ).animate(reverseSecondary),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
