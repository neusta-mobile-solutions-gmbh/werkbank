import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension FocusNodeKnobsExtension on KnobsComposer {
  Knob<FocusNode> focusNode(
    String label, {
    bool isInitiallyFocused = false,
  }) {
    final knob = FocusNodeKnob(
      label: label,
      isInitiallyFocused: isInitiallyFocused,
    );
    registerKnob(knob);
    return knob;
  }
}
