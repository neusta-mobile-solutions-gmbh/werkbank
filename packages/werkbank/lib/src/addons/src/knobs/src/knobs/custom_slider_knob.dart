import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob_types/nullable_knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob_types/regular_knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs_composer.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Knobs}
extension CustomSliderKnobExtension on KnobsComposer {
  /// Creates a knob for a generic type [T] controlled by a slider in the UI.
  ///
  /// {@template werkbank.knobs.customSlider.use}
  /// You can use this to create custom knobs for types that can be mapped to
  /// a number.
  /// {@endtemplate}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.customSlider}
  /// The [min] and [max] parameters define the slider's range for the type [T].
  ///
  /// [encoder] converts a value of type [T] to a [double] for the slider.
  ///
  /// [decoder] converts a [double] from the slider back to a value of type [T].
  /// Encoding a value of type [T] and then decoding it should yield the
  /// original value.
  /// The reverse must not necessarily hold, which can be used for example for
  /// non uniform snapping/divisions.
  ///
  /// [divisions] sets the number of discrete divisions if non-`null`.
  ///
  /// [valueLabel] is a function that returns the display label for each value.
  ///
  /// See the example below for how to use this to create a [TimeOfDay] knob:
  /// ```dart
  /// extension TimeOfDayKnobExtension on KnobsComposer {
  ///   WritableKnob<TimeOfDay> timeOfDay(
  ///     String label, {
  ///     required TimeOfDay initialValue,
  ///     TimeOfDay? min,
  ///     TimeOfDay? max,
  ///   }) {
  ///     return customSlider(
  ///       label,
  ///       initialValue: initialValue,
  ///       min: min ?? const TimeOfDay(hour: 0, minute: 0),
  ///       max: max ?? const TimeOfDay(hour: 23, minute: 59),
  ///       divisions: 24 * 60,
  ///       encoder: _timeOfDayEncoder,
  ///       decoder: _timeOfDayDecoder,
  ///       valueFormatter: _timeOfDayFormatter,
  ///     );
  ///   }
  /// }
  ///
  /// extension NullableTimeOfDayKnobExtension on NullableKnobsComposer {
  ///   WritableKnob<TimeOfDay?> timeOfDay(
  ///     String label, {
  ///     required TimeOfDay initialValue,
  ///     bool initiallyNull = false,
  ///     TimeOfDay? min,
  ///     TimeOfDay? max,
  ///   }) {
  ///     return customSlider(
  ///       label,
  ///       initialValue: initialValue,
  ///       initiallyNull: initiallyNull,
  ///       min: min ?? const TimeOfDay(hour: 0, minute: 0),
  ///       max: max ?? const TimeOfDay(hour: 23, minute: 59),
  ///       divisions: 24 * 60,
  ///       encoder: _timeOfDayEncoder,
  ///       decoder: _timeOfDayDecoder,
  ///       valueFormatter: _timeOfDayFormatter,
  ///     );
  ///   }
  /// }
  ///
  /// TimeOfDay _timeOfDayDecoder(double value) {
  ///   final hours = value ~/ 60;
  ///   final minutes = (value % 60).toInt();
  ///   return TimeOfDay(hour: hours, minute: minutes);
  /// }
  ///
  /// double _timeOfDayEncoder(TimeOfDay time) {
  ///   return (time.hour * 60 + time.minute).toDouble();
  /// }
  ///
  /// String _timeOfDayFormatter(TimeOfDay time) {
  ///   final hours = time.hour.toString().padLeft(2, '0');
  ///   final minutes = time.minute.toString().padLeft(2, '0');
  ///   return '$hours:$minutes';
  /// }
  /// ```
  /// {@endtemplate}
  WritableKnob<T> customSlider<T>(
    String label, {
    required T initialValue,
    required T min,
    required T max,
    int? divisions,
    required DoubleEncoder<T> encoder,
    required DoubleDecoder<T> decoder,
    required ValueFormatter<T> valueLabel,
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
        valueLabel: valueLabel,
        enabled: true,
      ),
    );
  }
}

/// {@category Knobs}
extension NullableCustomSliderKnobExtension on NullableKnobsComposer {
  /// Creates a nullable knob for a generic type [T] controlled by a slider
  /// in the UI.
  ///
  /// {@macro werkbank.knobs.customSlider.use}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.customSlider}
  WritableKnob<T?> customSlider<T extends Object>(
    String label, {
    required T initialValue,
    bool initiallyNull = false,
    required T min,
    required T max,
    int? divisions,
    required DoubleEncoder<T> encoder,
    required DoubleDecoder<T> decoder,
    required ValueFormatter<T> valueLabel,
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
        valueLabel: valueLabel,
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
    required this.valueLabel,
    required this.decoder,
    required this.encoder,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final T min;
  final T max;
  final int? divisions;
  final ValueFormatter<T> valueLabel;
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
      valueFormatter: (d) => valueLabel(decoder(d)),
      onChanged: enabled
          ? (value) => valueNotifier.value = decoder(value)
          : null,
    );
  }
}
