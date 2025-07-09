import 'package:werkbank/werkbank.dart';

@Deprecated(
  'Use customDropdown knob instead. '
  'Also consider writing a custom knob as an extension. '
  'See the "Knobs" topic in the documentation for more information. '
  'This will be removed in a future version.',
)
extension ListKnobExtension on KnobsComposer {
  @Deprecated(
    'Use customDropdown knob instead. '
    'Also consider writing a custom knob as an extension. '
    'See the "Knobs" topic in the documentation for more information. '
    'This will be removed in a future version.',
  )
  WritableKnob<T> list<T>(
    String label, {
    required List<T> options,
    required String Function(T) optionLabel,
    T? initialOption,
  }) {
    assert(
      options.isNotEmpty,
      'List of options must not be empty',
    );
    return customDropdown(
      label,
      initialValue: initialOption ?? options.first,
      options: options,
      optionLabel: optionLabel,
    );
  }
}

@Deprecated(
  'Use customDropdown knob instead. '
  'Also consider writing a custom knob as an extension. '
  'See the "Knobs" topic in the documentation for more information. '
  'This will be removed in a future version.',
)
extension NullableListKnobExtension on NullableKnobsComposer {
  @Deprecated(
    'Use customDropdown knob instead. '
    'Also consider writing a custom knob as an extension. '
    'See the "Knobs" topic in the documentation for more information. '
    'This will be removed in a future version.',
  )
  WritableKnob<T?> list<T extends Object>(
    String label, {
    required List<T> options,
    required String Function(T) optionLabel,
    T? initialOption,
    bool initiallyNull = false,
  }) {
    assert(
      options.isNotEmpty,
      'List of options must not be empty',
    );
    return customDropdown(
      label,
      initialValue: initialOption ?? options.first,
      initiallyNull: initiallyNull,
      options: options,
      optionLabel: optionLabel,
    );
  }
}
