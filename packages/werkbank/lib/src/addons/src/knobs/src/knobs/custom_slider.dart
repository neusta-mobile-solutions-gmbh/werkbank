import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension CustomSliderKnobExtension on KnobsComposer {
  WritableKnob<T> customSlider<T>(
    String label, {
    required T initialValue,
    required T min,
    required T max,
    int? divisions,
    required DoubleEncoder<T> doubleEncoder,
    required DoubleDecoder<T> doubleDecoder,
    required ValueFormatter<T> valueFormatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CustomSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        divisions: divisions,
        doubleEncoder: doubleEncoder,
        doubleDecoder: doubleDecoder,
        valueFormatter: valueFormatter,
        enabled: true,
      ),
    );
  }
}

extension NullableCustomKnobExtension on NullableKnobs {
  WritableKnob<T?> customSlider<T extends Object>(
    String label, {
    required T initialValue,
    bool initiallyNull = false,
    required T min,
    required T max,
    int? divisions,
    required DoubleEncoder<T> doubleEncoder,
    required DoubleDecoder<T> doubleDecoder,
    required ValueFormatter<T> valueFormatter,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _CustomSliderKnob(
        valueNotifier: valueNotifier,
        min: min,
        max: max,
        divisions: divisions,
        doubleEncoder: doubleEncoder,
        doubleDecoder: doubleDecoder,
        valueFormatter: valueFormatter,
        enabled: enabled,
      ),
    );
  }
}

class _CustomSliderKnob<T> extends StatelessWidget {
  const _CustomSliderKnob({
    required this.valueNotifier,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueFormatter,
    required this.doubleDecoder,
    required this.doubleEncoder,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final T min;
  final T max;
  final int? divisions;
  final ValueFormatter<T> valueFormatter;
  final DoubleDecoder<T> doubleDecoder;
  final DoubleEncoder<T> doubleEncoder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WSlider(
      value: doubleEncoder(valueNotifier.value),
      min: doubleEncoder(min),
      max: doubleEncoder(max),
      divisions: divisions,
      valueFormatter: (d) => valueFormatter(doubleDecoder(d)),
      onChanged: enabled
          ? (value) => valueNotifier.value = doubleDecoder(value)
          : null,
    );
  }
}

typedef ValueFormatter<T> = String Function(T value);

typedef DoubleEncoder<T> = double Function(T value);
typedef DoubleDecoder<T> = T Function(double value);
