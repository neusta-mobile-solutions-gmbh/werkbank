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
    required DoubleEncoder<T> encoder,
    required DoubleDecoder<T> decoder,
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
        encoder: encoder,
        decoder: decoder,
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
    required DoubleEncoder<T> encoder,
    required DoubleDecoder<T> decoder,
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
        encoder: encoder,
        decoder: decoder,
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
    required this.decoder,
    required this.encoder,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final T min;
  final T max;
  final int? divisions;
  final ValueFormatter<T> valueFormatter;
  final DoubleDecoder<T> decoder;
  final DoubleEncoder<T> encoder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WSlider(
      value: encoder(valueNotifier.value),
      min: encoder(min),
      max: encoder(max),
      divisions: divisions,
      valueFormatter: (d) => valueFormatter(decoder(d)),
      onChanged: enabled
          ? (value) => valueNotifier.value = decoder(value)
          : null,
    );
  }
}
