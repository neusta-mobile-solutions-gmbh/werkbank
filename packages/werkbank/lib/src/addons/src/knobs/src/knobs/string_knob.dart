import 'package:werkbank/src/addons/src/knobs/knobs.dart';

/// {@category Knobs}
extension StringKnobExtension on KnobsComposer {
  /// Creates a string knob controlled by a text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  WritableKnob<String> string(
    String label, {
    required String initialValue,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
    );
  }

  /// Creates a string knob controlled by a multi-line text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  WritableKnob<String> stringMultiLine(
    String label, {
    required String initialValue,
  }) {
    return customFieldMultiLine(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
    );
  }
}

/// {@category Knobs}
extension NullableStringKnobExtension on NullableKnobsComposer {
  /// Creates a nullable string knob controlled by a text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  WritableKnob<String?> string(
    String label, {
    required String initialValue,
    bool initiallyNull = false,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
      initiallyNull: initiallyNull,
    );
  }

  /// Creates a nullable string knob controlled by a multi-line
  /// text field in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  WritableKnob<String?> stringMultiLine(
    String label, {
    required String initialValue,
    bool initiallyNull = false,
  }) {
    return customFieldMultiLine(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
      initiallyNull: initiallyNull,
    );
  }
}

String _identityFormatter(String value) => value;
