import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob_types/focus_node_knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs_composer.dart';

/// {@category Knobs}
extension FocusNodeKnobsExtension on KnobsComposer {
  /// Creates an [FocusNode] knob controlled by a switch in the UI.
  ///
  /// {@macro werkbank.knobs.label}
  ///
  /// If [isInitiallyFocused] is `true`, the focus node will try to
  /// request focus when the knob is created.
  /// However, since only one focus node can be focused at a time,
  /// this may not always succeed.
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
