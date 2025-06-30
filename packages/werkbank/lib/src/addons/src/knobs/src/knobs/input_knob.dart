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

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
      text: widget.formatter(widget.valueNotifier.value),
    );
    _textEditingController.addListener(_textEditingControllerChanged);
    widget.valueNotifier.addListener(_knobChanged);
    _focusNode.addListener(_focusChanged);
  }

  void _textEditingControllerChanged() {
    final result = widget.parser(_textEditingController.text);
    switch (result) {
      case InputParseSuccess(:final value):
        setState(() => _errorLabel = null);
        widget.valueNotifier.value = value;
      case InputParseError(:final errorLabel):
        setState(() => _errorLabel = errorLabel);
    }
  }

  void _knobChanged() {
    if (!_focusNode.hasFocus) {
      _textEditingController.text = widget.formatter(
        widget.valueNotifier.value,
      );
    }
  }

  void _focusChanged() {
    if (!_focusNode.hasFocus && _errorLabel == null) {
      _textEditingController.text = widget.formatter(
        widget.valueNotifier.value,
      );
    }
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_knobChanged);
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
