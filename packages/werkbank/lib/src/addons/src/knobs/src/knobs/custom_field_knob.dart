import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

/// {@category Knobs}
extension CustomFieldKnobExtension on KnobsComposer {
  /// Creates a knob for a generic type [T] controlled by a text field
  /// in the UI.
  ///
  /// {@template werkbank.knobs.customField.use}
  /// You can use this to create custom knobs for editing values of type [T]
  /// using a text field.
  /// {@endtemplate}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@template werkbank.knobs.customField.parserFormatter}
  /// The [parser] function parses the user input [String]
  /// and returns an [InputParseResult].
  /// If the input is valid, it should return an [InputParseSuccess]
  /// with the parsed value of type [T].
  /// If the input is invalid, it should return an [InputParseError]
  /// with a short error message.
  /// The [parser] is allowed to accept multiple formats
  /// that parse to the same value.
  ///
  /// The [formatter] function converts a value of type [T] back into a [String]
  /// representation.
  /// Ideally parsing this formatted string yields an [InputParseSuccess]
  /// with the original value.
  /// {@endtemplate}
  ///
  /// {@template werkbank.knobs.customField.example}
  /// See the example below for how to use this to create a [BigInt] knob:
  /// ```dart
  /// extension BigIntKnobExtension on KnobsComposer {
  ///   WritableKnob<BigInt> bigInt(
  ///     String label, {
  ///     required BigInt initialValue,
  ///   }) {
  ///     return customField(
  ///       label,
  ///       initialValue: initialValue,
  ///       parser: _bigIntInputParser,
  ///       formatter: _bigIntInputFormatter,
  ///     );
  ///   }
  /// }
  ///
  /// extension NullableBigIntKnobExtension on NullableKnobsComposer {
  ///   WritableKnob<BigInt?> bigInt(
  ///     String label, {
  ///     required BigInt initialValue,
  ///     bool initiallyNull = false,
  ///   }) {
  ///     return customField(
  ///       label,
  ///       initialValue: initialValue,
  ///       parser: _bigIntInputParser,
  ///       formatter: _bigIntInputFormatter,
  ///       initiallyNull: initiallyNull,
  ///     );
  ///   }
  /// }
  ///
  /// InputParseResult<BigInt> _bigIntInputParser(String input) {
  ///   final trimmedInput = input.trim();
  ///   if (trimmedInput.isEmpty) {
  ///     return InputParseSuccess(BigInt.zero);
  ///   }
  ///   final parsedValue = BigInt.tryParse(trimmedInput);
  ///   return parsedValue != null
  ///       ? InputParseSuccess(parsedValue)
  ///       : InputParseError('Invalid BigInt format');
  /// }
  ///
  /// String _bigIntInputFormatter(BigInt value) => value.toString();
  /// ```
  /// {@endtemplate}
  WritableKnob<T> customField<T>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required ValueFormatter<T> formatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CustomFieldKnob(
        valueNotifier: valueNotifier,
        parser: parser,
        formatter: formatter,
        isMultiLine: false,
        enabled: true,
      ),
      rebuildKnobBuilderOnChange: false,
    );
  }

  /// Creates a knob for a generic type [T] controlled by a multi-line
  /// text field in the UI.
  ///
  /// {@macro werkbank.knobs.customField.use}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.regularInitial}
  ///
  /// {@macro werkbank.knobs.customField.parserFormatter}
  ///
  /// {@template werkbank.knobs.customFieldMultiLine.example}
  /// See the example below for how to use this to create a `List<String>` knob:
  /// ```dart
  /// extension StringListKnobExtension on KnobsComposer {
  ///   WritableKnob<List<String>> stringList(
  ///     String label, {
  ///     required List<String> initialValue,
  ///   }) {
  ///     return customFieldMultiLine(
  ///       label,
  ///       initialValue: initialValue,
  ///       parser: _stringListInputParser,
  ///       formatter: _stringListInputFormatter,
  ///     );
  ///   }
  /// }
  ///
  /// extension NullableStringListKnobExtension on NullableKnobsComposer {
  ///   WritableKnob<List<String>?> stringList(
  ///     String label, {
  ///     required List<String> initialValue,
  ///     bool initiallyNull = false,
  ///   }) {
  ///     return customFieldMultiLine(
  ///       label,
  ///       initialValue: initialValue,
  ///       parser: _stringListInputParser,
  ///       formatter: _stringListInputFormatter,
  ///       initiallyNull: initiallyNull,
  ///     );
  ///   }
  /// }
  ///
  /// InputParseResult<List<String>> _stringListInputParser(String input) {
  ///   final trimmedInput = input.trim();
  ///   if (trimmedInput.isEmpty) {
  ///     return const InputParseSuccess([]);
  ///   }
  ///   return InputParseSuccess(
  ///     trimmedInput.split('\n').map((e) => e.trim()).toList(),
  ///   );
  /// }
  ///
  /// String _stringListInputFormatter(List<String> value) => value.join('\n');
  /// ```
  /// {@endtemplate}
  WritableKnob<T> customFieldMultiLine<T>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required ValueFormatter<T> formatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CustomFieldKnob(
        valueNotifier: valueNotifier,
        parser: parser,
        formatter: formatter,
        isMultiLine: true,
        enabled: true,
      ),
      rebuildKnobBuilderOnChange: false,
      forceSpaciousLayout: true,
    );
  }
}

/// {@category Knobs}
extension NullableCustomFieldKnobExtension on NullableKnobsComposer {
  /// Creates a nullable knob for a generic type [T] controlled by a text field
  /// in the UI.
  ///
  /// {@macro werkbank.knobs.customField.use}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.customField.parserFormatter}
  ///
  /// {@macro werkbank.knobs.customField.example}
  WritableKnob<T?> customField<T extends Object>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required ValueFormatter<T> formatter,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _CustomFieldKnob(
        valueNotifier: valueNotifier,
        parser: parser,
        formatter: formatter,
        isMultiLine: false,
        enabled: enabled,
      ),
      rebuildKnobBuilderOnChange: false,
    );
  }

  /// Creates a nullable knob for a generic type [T] controlled by a
  /// multi-line text field in the UI.
  ///
  /// {@macro werkbank.knobs.customField.use}
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// {@macro werkbank.knobs.nullableInitial}
  ///
  /// {@macro werkbank.knobs.customField.parserFormatter}
  ///
  /// {@macro werkbank.knobs.customFieldMultiLine.example}
  WritableKnob<T?> customFieldMultiLine<T extends Object>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required ValueFormatter<T> formatter,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _CustomFieldKnob(
        valueNotifier: valueNotifier,
        parser: parser,
        formatter: formatter,
        isMultiLine: true,
        enabled: enabled,
      ),
      rebuildKnobBuilderOnChange: false,
      forceSpaciousLayout: true,
    );
  }
}

class _CustomFieldKnob<T> extends StatefulWidget {
  const _CustomFieldKnob({
    required this.valueNotifier,
    required this.parser,
    required this.formatter,
    required this.isMultiLine,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final InputParser<T> parser;
  final ValueFormatter<T> formatter;
  final bool isMultiLine;
  final bool enabled;

  @override
  State<_CustomFieldKnob<T>> createState() => _CustomFieldKnobState();
}

class _CustomFieldKnobState<T> extends State<_CustomFieldKnob<T>> {
  late TextEditingController _textEditingController;
  final _focusNode = FocusNode();
  TextSpan? _errorLabel;
  bool _handWrittenError = false;
  (String, InputParseResult<T>)? _parseCache;

  InputParseResult<T> get _parseResult {
    final input = _textEditingController.text;
    switch (_parseCache) {
      case (final cacheInput, final parseResult) when cacheInput == input:
        return parseResult;
      case _:
        final parseResult = widget.parser(input);
        _parseCache = (input, parseResult);
        return parseResult;
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
      text: widget.formatter(widget.valueNotifier.value),
    );
    _textEditingController.addListener(_syncValues);
    widget.valueNotifier.addListener(_syncValues);
    _focusNode.addListener(_focusChanged);
  }

  @override
  void didUpdateWidget(covariant _CustomFieldKnob<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    var sync = false;
    if (oldWidget.valueNotifier != widget.valueNotifier) {
      oldWidget.valueNotifier.removeListener(_syncValues);
      widget.valueNotifier.addListener(_syncValues);
      sync = true;
    }
    if (oldWidget.formatter != widget.formatter && !_focusNode.hasFocus) {
      sync = true;
    }
    if (oldWidget.parser != widget.parser) {
      _parseCache = null;
      if (!_focusNode.hasFocus) {
        _updateFromText(updateValue: false);
      }
      sync = true;
    }
    if (sync) {
      _syncValues();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (!_focusNode.hasFocus) {
      _updateFromText(updateValue: false);
    }
    _syncValues();
  }

  void _updateFromText({bool updateValue = true}) {
    switch (_parseResult) {
      case InputParseSuccess(:final value):
        setState(() {
          _errorLabel = null;
          _handWrittenError = false;
        });
        if (updateValue) {
          widget.valueNotifier.value = value;
        }
      case InputParseError(:final errorLabel):
        setState(() {
          _errorLabel = errorLabel;
          _handWrittenError |= _focusNode.hasFocus;
        });
    }
  }

  void _updateFromKnob() {
    _textEditingController.text = widget.formatter(
      widget.valueNotifier.value,
    );
    _updateFromText(updateValue: false);
  }

  void _syncValues() {
    if (_focusNode.hasFocus) {
      _updateFromText();
    } else if (!_handWrittenError || _errorLabel == null) {
      _updateFromKnob();
    }
  }

  void _focusChanged() {
    if (!_focusNode.hasFocus && (!_handWrittenError || _errorLabel == null)) {
      _updateFromKnob();
    }
    if (_focusNode.hasFocus && _errorLabel != null && !_handWrittenError) {
      setState(() {
        _handWrittenError = true;
      });
    }
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_syncValues);
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return WTextField(
      controller: _textEditingController,
      focusNode: _focusNode,
      label: _errorLabel == null
          ? null
          : Text.rich(
              _errorLabel!,
              style: _handWrittenError
                  ? null
                  : TextStyle(
                      // TODO(lzuttermeister): Use theme colors.
                      color: colorScheme.fieldContent.withValues(alpha: 0.8),
                    ),
            ),
      maxLines: widget.isMultiLine ? 3 : 1,
      enabled: widget.enabled,
    );
  }
}

/// A function that parses a [String] into an [InputParseResult].
/// This is either a [InputParseSuccess] with a value of type [T]
/// or an [InputParseError] with an error message.
typedef InputParser<T> = InputParseResult<T> Function(String input);

/// The result of parsing an input [String] using an [InputParser].
sealed class InputParseResult<T> {
  const InputParseResult();
}

/// A successful parsing result containing the parsed value of type [T].
class InputParseSuccess<T> extends InputParseResult<T> {
  const InputParseSuccess(this.value);

  final T value;
}

/// A parsing error result containing an error message.
class InputParseError<T> extends InputParseResult<T> {
  InputParseError(String errorLabel) : errorLabel = TextSpan(text: errorLabel);

  const InputParseError.textSpan(this.errorLabel);

  final TextSpan errorLabel;
}
