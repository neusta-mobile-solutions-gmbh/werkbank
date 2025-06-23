import 'package:flutter/material.dart';

/// This is a workaround because the original AnimationController does not
/// notify its listeners when it was stopped.
///
/// If only the Knob would stop the AnimationController, this would not be
/// necessary. But the AnimationController can also be stopped by
/// the user of the Knob. And the Knob-Control needs to notice that.

class VerboseAnimationController extends AnimationController {
  VerboseAnimationController({
    super.value,
    super.duration,
    super.reverseDuration,
    super.debugLabel,
    super.lowerBound = 0.0,
    super.upperBound = 1.0,
    super.animationBehavior = AnimationBehavior.normal,
    required super.vsync,
  });

  WasStoppedNotifier wasStopped = WasStoppedNotifier();

  @override
  void stop({bool canceled = true}) {
    super.stop(canceled: canceled);
    _notifyStop();
  }

  void _notifyStop() {
    wasStopped.notify();
  }
}

class WasStoppedNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
