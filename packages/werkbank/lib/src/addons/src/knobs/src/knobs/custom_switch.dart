import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension CustomSwitchKnobExtension on KnobsComposer {
  /// Creates a knob for a generic type [T] controlled by a switch in the UI.
  ///
  /// {@template werkbank.knobs.customSwitch.use}
  /// You can use this to create custom knobs for switching between two
  /// values of type [T].
  /// {@endtemplate}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.customSwitch}
  /// The [leftValue] and [rightValue] parameters specify the two values
  /// of type [T] that the switch toggles between.
  ///
  /// [leftLabel] and [rightLabel] define the labels shown for the
  /// left and right positions of the switch, respectively.
  ///
  /// For example, you can create a switch for toggling between
  /// [Brightness] values like this:
  /// ```dart
  /// extension BrightnessKnobExtension on KnobsComposer {
  ///   WritableKnob<Brightness> brightness(
  ///       String label, {
  ///         required Brightness initialValue,
  ///       }) {
  ///     return customSwitch(
  ///       label,
  ///       initialValue: initialValue,
  ///       leftValue: Brightness.dark,
  ///       rightValue: Brightness.light,
  ///       leftLabel: 'DARK',
  ///       rightLabel: 'LIGHT',
  ///     );
  ///   }
  /// }
  ///
  /// extension NullableBrightnessKnobExtension on NullableKnobsComposer {
  ///   WritableKnob<Brightness?> brightness(
  ///       String label, {
  ///         required Brightness initialValue,
  ///         bool initiallyNull = false,
  ///       }) {
  ///     return customSwitch(
  ///       label,
  ///       initialValue: initialValue,
  ///       initiallyNull: initiallyNull,
  ///       leftValue: Brightness.dark,
  ///       rightValue: Brightness.light,
  ///       leftLabel: 'DARK',
  ///       rightLabel: 'LIGHT',
  ///     );
  ///   }
  /// }
  /// ```
  /// {@endtemplate}
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

extension NullableCustomSwitchKnobExtension on NullableKnobsComposer {
  /// Creates a nullable knob for a generic type [T] controlled by a switch
  /// in the UI.
  ///
  /// {@macro werkbank.knobs.customSwitch.use}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.customSwitch}
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
