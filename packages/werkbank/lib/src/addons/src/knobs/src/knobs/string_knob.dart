import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension StringKnobExtension on KnobsComposer {
  WritableKnob<String> string(
    String label, {
    required String initialValue,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _StringKnob(
        valueNotifier: valueNotifier,
        isMultiLine: false,
        enabled: true,
      ),
      rebuildKnobBuilderOnChange: false,
    );
  }

  WritableKnob<String> stringMultiLine(
    String label, {
    required String initialValue,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _StringKnob(
        valueNotifier: valueNotifier,
        isMultiLine: true,
        enabled: true,
      ),
      rebuildKnobBuilderOnChange: false,
      forceSpaciousLayout: true,
    );
  }
}

extension NullableStringKnobExtension on NullableKnobs {
  WritableKnob<String?> string(
    String label, {
    required String initialValue,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _StringKnob(
        valueNotifier: valueNotifier,
        isMultiLine: false,
        enabled: enabled,
      ),
      rebuildKnobBuilderOnChange: false,
    );
  }

  WritableKnob<String?> stringMultiLine(
    String label, {
    required String initialValue,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _StringKnob(
        valueNotifier: valueNotifier,
        isMultiLine: true,
        enabled: enabled,
      ),
      rebuildKnobBuilderOnChange: false,
      forceSpaciousLayout: true,
    );
  }
}

class _StringKnob extends StatefulWidget {
  const _StringKnob({
    required this.valueNotifier,
    required this.isMultiLine,
    required this.enabled,
  });

  final ValueNotifier<String> valueNotifier;
  final bool isMultiLine;
  final bool enabled;

  @override
  State<_StringKnob> createState() => _StringKnobState();
}

class _StringKnobState extends State<_StringKnob> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
      text: widget.valueNotifier.value,
    );
    _textEditingController.addListener(_textEditingControllerChanged);
    widget.valueNotifier.addListener(_knobChanged);
  }

  void _textEditingControllerChanged() {
    widget.valueNotifier.value = _textEditingController.text;
  }

  void _knobChanged() {
    if (widget.valueNotifier.value != _textEditingController.text) {
      _textEditingController.text = widget.valueNotifier.value;
    }
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_knobChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WTextField(
      controller: _textEditingController,
      maxLines: widget.isMultiLine ? 3 : 1,
      enabled: widget.enabled,
    );
  }
}
