import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension DoubleKnobExtension on KnobsComposer {
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

extension NullableDoubleKnobExtension on NullableKnobs {
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
