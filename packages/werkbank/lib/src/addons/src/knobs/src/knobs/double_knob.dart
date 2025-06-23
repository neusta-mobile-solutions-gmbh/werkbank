import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension DoubleKnobExtension on KnobsComposer {
  WritableKnob<double> doubleSlider(
    String label, {
    required double initialValue,
    double min = 0,
    double max = 1,
    int? divisions,
    DoubleFormatter valueFormatter = _DoubleSliderKnob.defaultFormatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _DoubleSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        divisions: divisions,
        valueFormatter: valueFormatter,
        enabled: true,
      ),
    );
  }
}

extension NullableDoubleKnobExtension on NullableKnobs {
  WritableKnob<double?> doubleSlider(
    String label, {
    required double initialValue,
    bool initiallyNull = false,
    double min = 0,
    double max = 1,
    int? divisions,
    DoubleFormatter valueFormatter = _DoubleSliderKnob.defaultFormatter,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _DoubleSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        divisions: divisions,
        valueFormatter: valueFormatter,
        enabled: enabled,
      ),
    );
  }
}

class _DoubleSliderKnob extends StatelessWidget {
  const _DoubleSliderKnob({
    required this.valueNotifier,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueFormatter,
    required this.enabled,
  });

  static String defaultFormatter(double value) {
    return value.toStringAsFixed(2);
  }

  final ValueNotifier<double> valueNotifier;
  final double min;
  final double max;
  final int? divisions;
  final DoubleFormatter valueFormatter;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WSlider(
      value: valueNotifier.value,
      onChanged: enabled ? valueNotifier.setValue : null,
      min: min,
      max: max,
      divisions: divisions,
      valueFormatter: valueFormatter,
    );
  }
}
