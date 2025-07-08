import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension CustomDropdownKnobExtension on KnobsComposer {
  WritableKnob<T> customDropdown<T>(
    String label, {
    required T initialValue,
    required List<T> options,
    required String Function(T) optionLabel,
  }) {
    assert(
      options.isNotEmpty,
      'List of options must not be empty',
    );
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CustomDropdownKnob<T>(
        valueNotifier: valueNotifier,
        options: options,
        optionLabel: optionLabel,
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
    required List<T> options,
    required String Function(T) optionLabel,
  }) {
    assert(
      options.isNotEmpty,
      'List of options must not be empty',
    );
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _CustomDropdownKnob<T>(
        valueNotifier: valueNotifier,
        options: options,
        optionLabel: optionLabel,
        enabled: enabled,
      ),
    );
  }
}

class _CustomDropdownKnob<T> extends StatelessWidget {
  const _CustomDropdownKnob({
    required this.valueNotifier,
    required this.options,
    required this.optionLabel,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final List<T> options;
  final String Function(T) optionLabel;
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
             that are not in the options? */
        for (final option in {...options, valueNotifier.value})
          WDropdownMenuItem(
            value: option,
            child: Text(
              optionLabel(option),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
