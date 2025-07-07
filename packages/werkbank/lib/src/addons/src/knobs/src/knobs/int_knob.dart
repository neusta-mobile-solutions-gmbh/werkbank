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
}

extension NullableIntKnobExtension on NullableKnobs {
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
}

String _defaultFormatter(int value) => value.toString();
