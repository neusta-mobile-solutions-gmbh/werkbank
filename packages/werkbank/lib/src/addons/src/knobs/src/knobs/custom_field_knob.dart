import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

extension CustomFieldKnobExt on KnobsComposer {
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

extension NullableInputKnobExt on NullableKnobs {
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
        setState(() => _errorLabel = null);
        if (updateValue) {
          widget.valueNotifier.value = value;
        }
      case InputParseError(:final errorLabel):
        setState(() => _errorLabel = errorLabel);
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
    } else if (_errorLabel == null) {
      _updateFromKnob();
    }
  }

  void _focusChanged() {
    if (!_focusNode.hasFocus && _errorLabel == null) {
      _updateFromKnob();
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
    return WTextField(
      controller: _textEditingController,
      focusNode: _focusNode,
      label: _errorLabel == null ? null : Text.rich(_errorLabel!),
      maxLines: widget.isMultiLine ? 3 : 1,
      enabled: widget.enabled,
    );
  }
}

typedef InputParser<T> = InputParseResult<T> Function(String input);

sealed class InputParseResult<T> {
  const InputParseResult();
}

class InputParseSuccess<T> extends InputParseResult<T> {
  const InputParseSuccess(this.value);

  final T value;
}

class InputParseError<T> extends InputParseResult<T> {
  InputParseError(String errorLabel) : errorLabel = TextSpan(text: errorLabel);

  const InputParseError.textSpan(this.errorLabel);

  final TextSpan errorLabel;
}
