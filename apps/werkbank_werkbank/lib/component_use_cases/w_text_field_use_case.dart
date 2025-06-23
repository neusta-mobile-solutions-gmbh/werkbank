import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wTextFieldUseCase(UseCaseComposer c) {
  c
    ..description('A text field.')
    ..tags([Tags.input])
    ..urls([]);

  c.constraints
    ..initial(width: 400)
    ..overview();

  final label = c.knobs.string('Label', initialValue: 'Label');
  final hintText = c.knobs.string('Hint', initialValue: 'Hint');
  final enabled = c.knobs.boolean('Enabled', initialValue: true);
  final showClearButton = c.knobs.boolean(
    'Show Clear Button',
    initialValue: false,
  );
  final maxLines = c.knobs.intSlider(
    'Max Lines',
    initialValue: 1,
    max: 5,
    min: 1,
  );

  c
    ..knobPreset('Disabled', () {
      enabled.value = false;
    })
    ..knobPreset('MultiLine', () {
      maxLines.value = 5;
    });

  return (context) {
    return WTextField(
      // TODO(lzuttermeister): Use nullable knobs for both
      label: label.value.isNotEmpty ? Text(label.value) : null,
      hintText: hintText.value.isNotEmpty ? hintText.value : null,
      maxLines: maxLines.value,
      enabled: enabled.value,
      showClearButton: showClearButton.value,
    );
  };
}
