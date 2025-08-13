import 'package:werkbank/src/addons/src/knobs/knobs.dart';

/// {@category Knobs}
extension BooleanKnobExtension on KnobsComposer {
  /// Creates a boolean knob controlled by a switch in the UI.
  ///
  /// {@template werkbank.knobs.label}
  /// The [label] specifies the text displayed in the UI for this knob.
  /// It also uniquely identifies the knob, ensuring its state persists across
  /// hot reloads.
  /// {@endtemplate}
  ///
  /// {@template werkbank.knobs.regularInitial}
  /// The [initialValue] defines the state of the knob when first created
  /// and when the initial knob preset is selected.
  /// {@endtemplate}
  ///
  /// {@template werkbank.knobs.boolean.labels}
  /// Use [falseLabel] and [trueLabel] to customize the switch labels.
  /// For example, set them to `'OFF'`/`'ON'` or `'NO'`/`'YES'` if this
  /// fits the parameter controlled by the knob better.
  /// {@endtemplate}
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

/// {@category Knobs}
extension NullableBooleanKnobExtension on NullableKnobsComposer {
  /// Creates a nullable boolean knob controlled by a switch in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@template werkbank.knobs.nullableInitial}
  /// If [initiallyNull] is `false`, [initialValue] defines the state of
  /// the knob when first created and when the initial knob preset is selected.
  /// If [initiallyNull] is `true`, the knob starts in a `null` state and is set
  /// to `null` when the initial knob preset is selected.
  /// In this case, [initialValue] still
  /// determines the initial value of the knob control in the UI, which is then
  /// selected when the `null` state is toggled off.
  /// {@endtemplate}
  ///
  /// {@macro werkbank.knobs.boolean.labels}
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
