import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension StringKnobExtension on KnobsComposer {
  WritableKnob<String> string(
    String label, {
    required String initialValue,
  }) {
    return input<String>(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
    );
  }

  WritableKnob<String> stringMultiLine(
    String label, {
    required String initialValue,
  }) {
    return inputMultiLine<String>(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
    );
  }
}

extension NullableStringKnobExtension on NullableKnobs {
  WritableKnob<String?> string(
    String label, {
    required String initialValue,
    bool initiallyNull = false,
  }) {
    return input<String>(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
      initiallyNull: initiallyNull,
    );
  }

  WritableKnob<String?> stringMultiLine(
    String label, {
    required String initialValue,
    bool initiallyNull = false,
  }) {
    return inputMultiLine<String>(
      label,
      initialValue: initialValue,
      parser: InputParseSuccess.new,
      formatter: _identityFormatter,
      initiallyNull: initiallyNull,
    );
  }
}

String _identityFormatter(String value) => value;
