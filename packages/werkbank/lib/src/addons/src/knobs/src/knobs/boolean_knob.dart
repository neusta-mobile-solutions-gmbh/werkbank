import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension BooleanKnobExtension on KnobsComposer {
  WritableKnob<bool> boolean(
    String label, {
    required bool initialValue,
    String falseLabel = 'FALSE',
    String trueLabel = 'TRUE',
  }) {
    return customSwitch(
      label,
      initialValue: initialValue,
      leftValue: false,
      rightValue: true,
      leftLabel: falseLabel,
      rightLabel: trueLabel,
    );
  }
}

extension NullableBooleanKnobExtension on NullableKnobs {
  WritableKnob<bool?> boolean(
    String label, {
    required bool initialValue,
    bool initiallyNull = false,
    String falseLabel = 'FALSE',
    String trueLabel = 'TRUE',
  }) {
    return customSwitch(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      leftValue: false,
      rightValue: true,
      leftLabel: falseLabel,
      rightLabel: trueLabel,
    );
  }
}
