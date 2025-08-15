import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Knobs}
extension DoubleKnobExtension on KnobsComposer {
  /// Creates a double knob controlled by a slider in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.doubleSlider}
  /// The [min] and [max] parameters define the slider's range.
  /// They default to 0 and 1.
  ///
  /// [divisions] sets the number of discrete divisions if non-`null`.
  ///
  /// [valueLabel] is a function that returns the display label for each value.
  /// This defaults to showing two decimal places.
  /// {@endtemplate}
  WritableKnob<double> doubleSlider(
    String label, {
    required double initialValue,
    double min = 0,
    double max = 1,
    int? divisions,
    @Deprecated('Use valueLabel instead') DoubleFormatter? valueFormatter,
    DoubleFormatter valueLabel = _defaultLabel,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      min: min,
      max: max,
      divisions: divisions,
      encoder: (v) => v,
      decoder: (d) => d,
      valueLabel: valueFormatter ?? valueLabel,
    );
  }

  /// Creates a double knob controlled by a text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.doubleField}
  /// [The [min] and [max] parameters define the range of allowed values.
  ///
  /// [allowInfinites] controls whether [double.infinity]
  /// or [double.negativeInfinity] values are accepted.
  /// Case-insensitive inputs of "inf", "infinity", "-inf" and "-infinity" are
  /// recognized.
  ///
  /// [allowNaN] controls whether [double.nan] is accepted as a values.
  /// Case-insensitive input of "nan" is recognized.
  /// {@endtemplate}
  WritableKnob<double> doubleField(
    String label, {
    required double initialValue,
    double? min,
    double? max,
    bool allowInfinites = false,
    bool allowNaN = false,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      parser: (input) => _doubleInputParser(
        input,
        min: min,
        max: max,
        allowInfinites: allowInfinites,
        allowNaN: allowNaN,
      ),
      formatter: _doubleFormatter,
    );
  }
}

/// {@category Knobs}
extension NullableDoubleKnobExtension on NullableKnobsComposer {
  /// Creates a nullable double knob controlled by a slider in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.doubleSlider}
  WritableKnob<double?> doubleSlider(
    String label, {
    required double initialValue,
    bool initiallyNull = false,
    double min = 0,
    double max = 1,
    int? divisions,
    @Deprecated('Use valueLabel instead') DoubleFormatter? valueFormatter,
    DoubleFormatter valueLabel = _defaultLabel,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      min: min,
      max: max,
      divisions: divisions,
      encoder: (v) => v,
      decoder: (d) => d,
      valueLabel: valueFormatter ?? valueLabel,
    );
  }

  /// Creates a nullable double knob controlled by a text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.doubleField}
  WritableKnob<double?> doubleField(
    String label, {
    required double initialValue,
    bool initiallyNull = false,
    double? min,
    double? max,
    bool allowInfinites = false,
    bool allowNaN = false,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      parser: (input) => _doubleInputParser(
        input,
        min: min,
        max: max,
        allowInfinites: allowInfinites,
        allowNaN: allowNaN,
      ),
      formatter: _doubleFormatter,
      initiallyNull: initiallyNull,
    );
  }
}

String _defaultLabel(double value) => value.toStringAsFixed(2);

String _doubleFormatter(double value) => value.toString();

InputParseResult<double> _doubleInputParser(
  String input, {
  double? min,
  double? max,
  bool allowInfinites = false,
  bool allowNaN = false,
}) {
  final double? value;
  switch (input.trim().toLowerCase()) {
    case '':
      return InputParseError('Input required');
    case 'nan':
      value = double.nan;
    case 'inf' || 'infinity':
      value = double.infinity;
    case '-inf' || '-infinity':
      value = double.negativeInfinity;
    case final trimmedInput:
      value = double.tryParse(trimmedInput);
  }
  if (value == null) {
    return InputParseError('Invalid number format');
  }
  if (value.isNaN && !allowNaN) {
    return InputParseError('NaN not allowed');
  }
  if (min != null && value < min) {
    return InputParseError('Must be ≥ ${_doubleFormatter(min)}');
  }
  if (max != null && value > max) {
    return InputParseError('Must be ≤ ${_doubleFormatter(max)}');
  }
  if (value.isInfinite && !allowInfinites) {
    return InputParseError('Infinity not allowed');
  }
  return InputParseSuccess(value);
}
