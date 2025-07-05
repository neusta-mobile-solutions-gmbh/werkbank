import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/components/components.dart';

extension InputKnobExt on KnobsComposer {
  WritableKnob<T> input<T>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required InputFormatter<T> formatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _InputKnob(
        valueNotifier: valueNotifier,
        parser: parser,
        formatter: formatter,
        isMultiLine: false,
        enabled: true,
      ),
      rebuildKnobBuilderOnChange: false,
    );
  }

  WritableKnob<T> inputMultiLine<T>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required InputFormatter<T> formatter,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _InputKnob(
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
  WritableKnob<T?> input<T extends Object>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required InputFormatter<T> formatter,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _InputKnob(
        valueNotifier: valueNotifier,
        parser: parser,
        formatter: formatter,
        isMultiLine: false,
        enabled: enabled,
      ),
      rebuildKnobBuilderOnChange: false,
    );
  }

  WritableKnob<T?> inputMultiLine<T extends Object>(
    String label, {
    required T initialValue,
    required InputParser<T> parser,
    required InputFormatter<T> formatter,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _InputKnob(
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

class _InputKnob<T> extends StatefulWidget {
  const _InputKnob({
    required this.valueNotifier,
    required this.parser,
    required this.formatter,
    required this.isMultiLine,
    required this.enabled,
  });

  final ValueNotifier<T> valueNotifier;
  final InputParser<T> parser;
  final InputFormatter<T> formatter;
  final bool isMultiLine;
  final bool enabled;

  @override
  State<_InputKnob<T>> createState() => _InputKnobState();
}

class _InputKnobState<T> extends State<_InputKnob<T>> {
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
  void didUpdateWidget(covariant _InputKnob<T> oldWidget) {
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
typedef InputFormatter<T> = String Function(T value);

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
