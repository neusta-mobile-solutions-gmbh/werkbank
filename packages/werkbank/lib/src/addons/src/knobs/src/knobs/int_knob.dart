import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension IntKnobExtension on KnobsComposer {
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
      doubleEncoder: (v) => v.toDouble(),
      doubleDecoder: (d) => d.toInt(),
      valueFormatter: valueFormatter,
    );
  }
}

extension NullableIntKnobExtension on NullableKnobs {
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
      doubleEncoder: (v) => v.toDouble(),
      doubleDecoder: (d) => d.toInt(),
      valueFormatter: valueFormatter,
    );
  }
}

typedef IntFormatter = String Function(int value);

String _defaultFormatter(int value) => value.toString();
