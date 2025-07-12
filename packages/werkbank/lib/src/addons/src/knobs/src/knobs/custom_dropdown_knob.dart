import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension CustomDropdownKnobExtension on KnobsComposer {
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
