import 'dart:core';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension MillisKnobExtension on KnobsComposer {
  /// Creates a duration knob controlled by a milliseconds slider in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.millis.slider}
  /// The [min] and [max] parameters define the slider's range.
  /// They default to [Durations.short1] and [Durations.extralong4].
  /// {@endtemplate}
  WritableKnob<Duration> millis(
    String label, {
    required Duration initialValue,
    Duration min = Durations.short1,
    Duration max = Durations.extralong4,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _MillisSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        enabled: true,
      ),
    );
  }
}

/// {@category Knobs}
extension NullableMillisKnobExtension on NullableKnobsComposer {
  /// Creates a nullable duration knob controlled by a milliseconds slider
  /// in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.millis.slider}
  WritableKnob<Duration?> millis(
    String label, {
    required Duration initialValue,
    bool initiallyNull = false,
    Duration min = Durations.short1,
    Duration max = Durations.extralong4,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _MillisSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        enabled: enabled,
      ),
    );
  }
}

class _MillisSliderKnob extends StatelessWidget {
  const _MillisSliderKnob({
    required this.valueNotifier,
    required this.min,
    required this.max,
    required this.enabled,
  });

  final ValueNotifier<Duration> valueNotifier;
  final Duration min;
  final Duration max;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WSlider(
      value: valueNotifier.value.inMilliseconds.toDouble(),
      onChanged: enabled
          ? (value) {
              valueNotifier.setValue(Duration(milliseconds: value.toInt()));
            }
          : null,
      min: min.inMilliseconds.toDouble(),
      max: max.inMilliseconds.toDouble(),
      divisions: max.inMilliseconds - min.inMilliseconds,
      valueFormatter: (value) => value.toStringAsFixed(0),
    );
  }
}
