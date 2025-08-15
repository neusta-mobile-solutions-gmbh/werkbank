import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';

/// {@category Knobs}
extension AnimationControllerKnobsExtension on KnobsComposer {
  Knob<AnimationController> animationController(
    String label, {
    double initialValue = 0,
    required Duration initialDuration,
    List<NamedDuration> durationOptions = _m3GuidelinesDurations,
  }) {
    final knob = AnimationControllerKnob(
      label: label,
      initialValue: initialValue,
      initialDuration: initialDuration,
      durationOptions: durationOptions.toSet(),
    );
    registerKnob(knob);
    return knob;
  }
}

const _m3GuidelinesDurations = [
  NamedDuration('short1', Durations.short1),
  NamedDuration('short2', Durations.short2),
  NamedDuration('short3', Durations.short3),
  NamedDuration('short4', Durations.short4),
  NamedDuration('medium1', Durations.medium1),
  NamedDuration('medium2', Durations.medium2),
  NamedDuration('medium3', Durations.medium3),
  NamedDuration('medium4', Durations.medium4),
  NamedDuration('long1', Durations.long1),
  NamedDuration('long2', Durations.long2),
  NamedDuration('long3', Durations.long3),
  NamedDuration('long4', Durations.long4),
  NamedDuration('extralong1', Durations.extralong1),
  NamedDuration('extralong2', Durations.extralong2),
  NamedDuration('extralong3', Durations.extralong3),
  NamedDuration('extralong4', Durations.extralong4),
];
