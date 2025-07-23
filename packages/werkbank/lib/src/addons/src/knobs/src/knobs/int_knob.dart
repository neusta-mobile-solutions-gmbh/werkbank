import 'package:werkbank/werkbank_old.dart';

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
  /// [valueLabel] is a function that returns the display label for each value.
  /// {@endtemplate}
  WritableKnob<int> intSlider(
    String label, {
    required int initialValue,
    int min = 0,
    int max = 10,
    @Deprecated('Use valueLabel instead') IntFormatter? valueFormatter,
    IntFormatter valueLabel = _defaultLabel,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      min: min,
      max: max,
      divisions: max - min,
      encoder: (v) => v.toDouble(),
      decoder: (d) => d.toInt(),
      valueLabel: valueFormatter ?? valueLabel,
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
    return customField(
      label,
      initialValue: initialValue,
      parser: (input) => _intInputParser(input, min: min, max: max),
      formatter: _intFormatter,
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
    @Deprecated('Use valueLabel instead') IntFormatter? valueFormatter,
    IntFormatter valueLabel = _defaultLabel,
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
      valueLabel: valueFormatter ?? valueLabel,
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
    return customField(
      label,
      initialValue: initialValue,
      parser: (input) => _intInputParser(input, min: min, max: max),
      formatter: _intFormatter,
      initiallyNull: initiallyNull,
    );
  }
}

String _defaultLabel(int value) => value.toString();

String _intFormatter(int value) => value.toString();

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
