import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

// We can't merge this with [FocusNodeKnob], since
// the [ValueGuardingKnobMixin] needs a concrete implementation
// of the [value] getter.
abstract class _FocusNodeKnobBase extends BuildableKnob<FocusNode> {
  _FocusNodeKnobBase({required super.label});

  FocusNode? _focusNode;

  @override
  FocusNode get value => _focusNode!;
}

class FocusNodeKnob extends _FocusNodeKnobBase
    with ValueGuardingKnobMixin<FocusNode> {
  FocusNodeKnob({
    required super.label,
    required this.isInitiallyFocused,
  });

  final bool isInitiallyFocused;

  @override
  void prepareForBuild(BuildContext context) {
    super.prepareForBuild(context);
    _focusNode = FocusNode();
    resetToInitial();
  }

  @override
  KnobSnapshot createSnapshot() => FocusNodeKnobSnapshot(
    isFocused: value.hasPrimaryFocus,
  );

  @override
  void tryLoadSnapshot(KnobSnapshot snapshot) {
    if (snapshot is FocusNodeKnobSnapshot) {
      _setFocus(snapshot.isFocused);
    }
  }

  @override
  void resetToInitial() {
    _setFocus(isInitiallyFocused);
  }

  void _setFocus(bool isFocused) {
    if (isFocused) {
      value.requestFocus();
    } else if (value.hasPrimaryFocus) {
      value.unfocus();
    }
  }

  @override
  Listenable get contentChangedListenable => value;

  @override
  void dispose() {
    _focusNode?.unfocus();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(label),
      control: ListenableBuilder(
        listenable: value,
        builder: (context, _) {
          return WSwitch(
            value: value.hasPrimaryFocus,
            onChanged: _setFocus,
            falseLabel: Text(
              context.sL10n.addons.knobs.knobs.focusnode.unfocused,
            ),
            trueLabel: Text(
              context.sL10n.addons.knobs.knobs.focusnode.focused,
            ),
          );
        },
      ),
    );
  }
}

class FocusNodeKnobSnapshot extends KnobSnapshot {
  const FocusNodeKnobSnapshot({
    required this.isFocused,
  });

  final bool isFocused;
}
