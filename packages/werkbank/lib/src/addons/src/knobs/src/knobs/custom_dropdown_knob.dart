import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension CustomDropdownKnobExtension on KnobsComposer {
  /// Creates a knob for a generic type [T] controlled by a dropdown in the UI.
  ///
  /// {@template werkbank.knobs.customDropdown.use}
  /// You can use this to create custom knobs for types with only a
  /// small number of possible values.
  /// {@endtemplate}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.customDropdown}
  /// The [values] parameter defines the list of selectable values of type [T].
  ///
  /// [valueLabel] is a function that returns the display label for each value.
  ///
  /// See the example below for how to use this to create an
  /// [AxisDirection] knob:
  /// ```dart
  /// extension AxisDirectionKnobExtension on KnobsComposer {
  ///   WritableKnob<AxisDirection> axisDirection(
  ///     String label, {
  ///     required AxisDirection initialValue,
  ///   }) {
  ///     return customDropdown(
  ///       label,
  ///       initialValue: initialValue,
  ///       values: AxisDirection.values,
  ///       valueLabel: _axisDirectionLabel,
  ///     );
  ///   }
  /// }
  ///
  /// extension NullableAxisDirectionKnobExtension on NullableKnobsComposer {
  ///   WritableKnob<AxisDirection?> axisDirection(
  ///     String label, {
  ///     required AxisDirection initialValue,
  ///     bool initiallyNull = false,
  ///   }) {
  ///     return customDropdown(
  ///       label,
  ///       initialValue: initialValue,
  ///       initiallyNull: initiallyNull,
  ///       values: AxisDirection.values,
  ///       valueLabel: _axisDirectionLabel,
  ///     );
  ///   }
  /// }
  ///
  /// String _axisDirectionLabel(AxisDirection direction) =>
  ///     switch (direction) {
  ///       AxisDirection.up => 'Up',
  ///       AxisDirection.down => 'Down',
  ///       AxisDirection.left => 'Left',
  ///       AxisDirection.right => 'Right',
  ///     };
  /// ```
  /// {@endtemplate}
  WritableKnob<T> customDropdown<T>(
    String label, {
    required T initialValue,
    required List<T> values,
    required String Function(T) valueLabel,
  }) {
    assert(
      values.isNotEmpty,
      'List of values must not be empty',
    );
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CustomDropdownKnob<T>(
        valueNotifier: valueNotifier,
        values: values,
        valueLabel: valueLabel,
        enabled: true,
      ),
    );
  }
}

/// {@category Knobs}
extension NullableCustomDropdownKnobExtension on NullableKnobsComposer {
  /// Creates a nullable knob for a generic type [T] controlled by a dropdown
  /// in the UI.
  ///
  /// {@macro werkbank.knobs.customDropdown.use}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.customDropdown}
  WritableKnob<T?> customDropdown<T extends Object>(
    String label, {
    required T initialValue,
    bool initiallyNull = false,
    required List<T> values,
    required String Function(T) valueLabel,
  }) {
    assert(
      values.isNotEmpty,
      'List of values must not be empty',
    );
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _CustomDropdownKnob<T>(
        valueNotifier: valueNotifier,
        values: values,
        valueLabel: valueLabel,
        enabled: enabled,
      ),
    );
  }
}

class _CustomDropdownKnob<T> extends StatelessWidget {
  const _CustomDropdownKnob({
    required this.valueNotifier,
    required this.values,
    required this.valueLabel,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final List<T> values;
  final String Function(T) valueLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WDropdown<T>(
      onChanged: enabled
          ? (value) {
              if (value != null) valueNotifier.value = value;
            }
          : null,
      value: valueNotifier.value,
      items: [
        /* TODO(lzuttermeister): Is this really the best way to handle values
             that are not in the values list? */
        for (final value in {...values, valueNotifier.value})
          WDropdownMenuItem(
            value: value,
            child: Text(
              valueLabel(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
