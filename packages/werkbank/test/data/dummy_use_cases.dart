import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder dummyUseCase(UseCaseComposer c) {
  c
    ..tags(['Dummy'])
    ..description('I am a dummy')
    ..urls(
      [
        'http://www.example.com',
      ],
    )
    ..background.color(Colors.white)
    ..constraints.supported(
      const BoxConstraints(
        minWidth: 10,
        maxWidth: 1000,
        minHeight: 10,
        maxHeight: 1000,
      ),
    )
    ..constraints.initial(
      width: 100,
      height: 100,
    )
    ..constraints.preset(
      'Large',
      width: 1000,
      height: 1000,
    );

  final stringKnob = c.knobs.string('String', initialValue: '');
  c.knobPreset('Dummy', () {
    stringKnob.value = 'Dummy';
  });

  return (context) {
    return Text(stringKnob.value);
  };
}
