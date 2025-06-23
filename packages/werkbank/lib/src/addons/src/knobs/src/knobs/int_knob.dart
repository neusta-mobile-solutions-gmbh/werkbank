import 'dart:core';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension IntKnobExtension on KnobsComposer {
  WritableKnob<int> intSlider(
    String label, {
    required int initialValue,
    int min = 0,
    int max = 10,
    IntFormatter valueFormatter = _IntSliderKnob.defaultFormatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _IntSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        valueFormatter: valueFormatter,
        enabled: true,
      ),
    );
  }
}

extension NullableIntKnobExtension on NullableKnobs {
  WritableKnob<int?> intSlider(
    String label, {
    required int initialValue,
    bool initiallyNull = false,
    int min = 0,
    int max = 10,
    IntFormatter valueFormatter = _IntSliderKnob.defaultFormatter,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _IntSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        valueFormatter: valueFormatter,
        enabled: enabled,
      ),
    );
  }
}

typedef IntFormatter = String Function(int value);

class _IntSliderKnob extends StatelessWidget {
  const _IntSliderKnob({
    required this.valueNotifier,
    required this.min,
    required this.max,
    required this.valueFormatter,
    required this.enabled,
  });

  static String defaultFormatter(int value) {
    return value.toString();
  }

  final ValueNotifier<int> valueNotifier;
  final int min;
  final int max;
  final IntFormatter valueFormatter;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WSlider(
      value: valueNotifier.value.toDouble(),
      onChanged: enabled
          ? (value) {
              valueNotifier.setValue(value.toInt());
            }
          : null,
      min: min.toDouble(),
      max: max.toDouble(),
      divisions: max - min,
      valueFormatter: (value) => valueFormatter(value.toInt()),
    );
  }
}
