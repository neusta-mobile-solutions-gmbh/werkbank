import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension CustomSwitchKnobExtension on KnobsComposer {
  WritableKnob<T> customSwitch<T>(
    String label, {
    required T initialValue,
    required T leftValue,
    required T rightValue,
    required String leftLabel,
    required String rightLabel,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CustomSwitchKnob<T>(
        valueNotifier: valueNotifier,
        leftValue: leftValue,
        rightValue: rightValue,
        leftLabel: leftLabel,
        rightLabel: rightLabel,
        enabled: true,
      ),
    );
  }
}

extension NullableCustomSwitchKnobExtension on NullableKnobs {
  WritableKnob<T?> customSwitch<T extends Object>(
    String label, {
    required T initialValue,
    bool initiallyNull = false,
    required T leftValue,
    required T rightValue,
    required String leftLabel,
    required String rightLabel,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _CustomSwitchKnob<T>(
        valueNotifier: valueNotifier,
        leftValue: leftValue,
        rightValue: rightValue,
        leftLabel: leftLabel,
        rightLabel: rightLabel,
        enabled: enabled,
      ),
    );
  }
}

class _CustomSwitchKnob<T> extends StatelessWidget {
  const _CustomSwitchKnob({
    required this.valueNotifier,
    required this.leftValue,
    required this.rightValue,
    required this.leftLabel,
    required this.rightLabel,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final T leftValue;
  final T rightValue;
  final String leftLabel;
  final String rightLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    late final bool isRight;
    try {
      final value = valueNotifier.value;
      if (value == rightValue) {
        isRight = true;
      } else if (value == leftValue) {
        isRight = false;
      } else {
        throw ArgumentError(
          'Value $value does not match either '
          'leftValue $leftValue or rightValue $rightValue',
        );
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      isRight = false;
    }

    return WSwitch(
      value: isRight,
      onChanged: enabled
          ? (v) => valueNotifier.value = v ? rightValue : leftValue
          : null,
      falseLabel: Text(leftLabel),
      trueLabel: Text(rightLabel),
    );
  }
}
