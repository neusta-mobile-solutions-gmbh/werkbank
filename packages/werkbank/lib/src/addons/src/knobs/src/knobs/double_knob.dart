import 'package:werkbank/werkbank.dart';

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
  /// [valueFormatter] customizes the display of the value.
  /// This defaults to showing two decimal places.
  /// {@endtemplate}
  WritableKnob<double> doubleSlider(
    String label, {
    required double initialValue,
    double min = 0,
    double max = 1,
    int? divisions,
    DoubleFormatter valueFormatter = _defaultFormatter,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      min: min,
      max: max,
      divisions: divisions,
      encoder: (v) => v,
      decoder: (d) => d,
      valueFormatter: valueFormatter,
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
    DoubleFormatter valueFormatter = _defaultFormatter,
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
      valueFormatter: valueFormatter,
    );
  }
}

String _defaultFormatter(double value) => value.toStringAsFixed(2);
