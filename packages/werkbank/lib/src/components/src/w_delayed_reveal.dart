import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WDelayedReveal extends StatefulWidget {
  factory WDelayedReveal({
    Key? key,
    Duration delay = Durations.short2,
    Duration revealDuration = Durations.medium4,
    required Widget placeholder,
    required Widget child,
  }) {
    return WDelayedReveal.randomDelay(
      key: key,
      minDelay: delay,
      maxDelay: delay,
      delayCurve: Curves.linear,
      revealDuration: revealDuration,
      placeholder: placeholder,
      child: child,
    );
  }

  const WDelayedReveal.randomDelay({
    super.key,
    this.minDelay = Durations.short2,
    this.maxDelay = Durations.medium2,
    this.delayCurve = Curves.easeIn,
    this.revealDuration = Durations.medium4,
    required this.placeholder,
    required this.child,
  }) : assert(minDelay >= Duration.zero, 'minDelay must be positive'),
       assert(maxDelay >= Duration.zero, 'maxDelay must be positive'),
       assert(
         minDelay <= maxDelay,
         'minDelay must be less than or equal to maxDelay',
       ),
       assert(
         revealDuration >= Duration.zero,
         'revealDuration must be positive',
       );

  final Duration minDelay;
  final Duration maxDelay;
  final Curve delayCurve;
  final Duration revealDuration;
  final Widget placeholder;
  final Widget child;

  @override
  State<WDelayedReveal> createState() => _SDelayedRevealState();
}

class _SDelayedRevealState extends State<WDelayedReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isSwitched = false;
  bool done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.revealDuration,
    );
    unawaited(_startRevealSequence());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startRevealSequence() async {
    final Duration delay;
    if (widget.minDelay == widget.maxDelay) {
      delay = widget.minDelay;
    } else {
      final random = Random();
      final delayFactor = widget.delayCurve.transform(random.nextDouble());
      final delayRange = widget.maxDelay - widget.minDelay;
      delay = widget.minDelay + delayRange * delayFactor;
    }
    await Future<void>.delayed(delay);
    if (mounted) {
      setState(() => isSwitched = true);
      await _controller.forward();
      setState(() => done = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (!done) widget.placeholder,
        FadeTransition(
          key: const ValueKey('child'),
          opacity: curvedAnimation,
          child: isSwitched ? widget.child : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
