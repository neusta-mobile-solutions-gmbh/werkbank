import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wSwitchUseCase(UseCaseComposer c) {
  c
    ..description(
      'A switch that can be used to toggle between two values',
    )
    ..tags([Tags.input]);

  c.constraints
    ..initial(width: 180)
    ..overview();

  final value = c.knobs.boolean('Value', initialValue: false);
  final falseLabelText = c.knobs.string('False Label', initialValue: 'FALSE');
  final trueLabelText = c.knobs.string('True Label', initialValue: 'TRUE');

  c
    ..knobPreset('On/Off', () {
      falseLabelText.value = 'OFF';
      trueLabelText.value = 'ON';
    })
    ..knobPreset('Yes/No', () {
      falseLabelText.value = 'NO';
      trueLabelText.value = 'YES';
    });
  return (context) {
    return WSwitch(
      value: value.value,
      onChanged: value.setValue,
      falseLabel: Text(falseLabelText.value),
      trueLabel: Text(trueLabelText.value),
    );
  };
}
