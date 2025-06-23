import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension BooleanKnobExtension on KnobsComposer {
  WritableKnob<bool> boolean(
    String label, {
    required bool initialValue,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _BooleanKnob(
        valueNotifier: valueNotifier,
        enabled: true,
      ),
    );
  }
}

extension NullableBooleanKnobExtension on NullableKnobs {
  WritableKnob<bool?> boolean(
    String label, {
    required bool initialValue,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _BooleanKnob(
        valueNotifier: valueNotifier,
        enabled: enabled,
      ),
    );
  }
}

class _BooleanKnob extends StatelessWidget {
  const _BooleanKnob({
    required this.valueNotifier,
    required this.enabled,
  });

  final ValueNotifier<bool> valueNotifier;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return WSwitch(
      value: valueNotifier.value,
      onChanged: enabled ? valueNotifier.setValue : null,
      falseLabel: Text(
        context.sL10n.addons.knobs.knobs.boolean.values.falseLabel,
      ),
      trueLabel: Text(
        context.sL10n.addons.knobs.knobs.boolean.values.trueLabel,
      ),
    );
  }
}
