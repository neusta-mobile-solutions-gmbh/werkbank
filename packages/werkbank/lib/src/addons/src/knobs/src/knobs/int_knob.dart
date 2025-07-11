import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension IntKnobExtension on KnobsComposer {
  /// Creates an integer knob controlled by a slider in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.intSlider}
  /// The [min] and [max] parameters define the slider's range.
  /// They default to 0 and 1.
  ///
  /// [valueFormatter] customizes the display of the value.
  /// {@endtemplate}
  WritableKnob<int> intSlider(
    String label, {
    required int initialValue,
    int min = 0,
    int max = 10,
    IntFormatter valueFormatter = _defaultFormatter,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      min: min,
      max: max,
      divisions: max - min,
      encoder: (v) => v.toDouble(),
      decoder: (d) => d.toInt(),
      valueFormatter: valueFormatter,
    );
  }

  /// Creates an integer knob controlled by a text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.intField}
  /// The [min] and [max] parameters define the range of allowed values.
  /// {@endtemplate}
  WritableKnob<int> intField(
    String label, {
    required int initialValue,
    int? min,
    int? max,
  }) {
    return customField<int>(
      label,
      initialValue: initialValue,
      parser: (input) => _intInputParser(input, min: min, max: max),
      formatter: _defaultFormatter,
    );
  }
}

/// {@category Knobs}
extension NullableIntKnobExtension on NullableKnobsComposer {
  /// Creates a nullable integer knob controlled by a slider in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.intSlider}
  WritableKnob<int?> intSlider(
    String label, {
    required int initialValue,
    bool initiallyNull = false,
    int min = 0,
    int max = 10,
    IntFormatter valueFormatter = _defaultFormatter,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      min: min,
      max: max,
      divisions: max - min,
      encoder: (v) => v.toDouble(),
      decoder: (d) => d.toInt(),
      valueFormatter: valueFormatter,
    );
  }

  /// Creates a nullable integer knob controlled by a text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.intField}
  WritableKnob<int?> intField(
    String label, {
    required int initialValue,
    bool initiallyNull = false,
    int? min,
    int? max,
  }) {
    return customField<int>(
      label,
      initialValue: initialValue,
      parser: (input) => _intInputParser(input, min: min, max: max),
      formatter: _defaultFormatter,
      initiallyNull: initiallyNull,
    );
  }
}

String _defaultFormatter(int value) => value.toString();

InputParseResult<int> _intInputParser(
  String input, {
  int? min,
  int? max,
}) {
  final trimmedInput = input.trim();
  if (trimmedInput.isEmpty) {
    return InputParseError('Input required');
  }

  final value = int.tryParse(trimmedInput);
  if (value == null) {
    return InputParseError('Invalid integer format');
  }

  if (min != null && value < min) {
    return InputParseError('Must be ≥ $min');
  }
  if (max != null && value > max) {
    return InputParseError('Must be ≤ $max');
  }

  return InputParseSuccess(value);
}
