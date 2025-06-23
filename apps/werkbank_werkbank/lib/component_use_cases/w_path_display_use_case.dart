import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wPathDisplayUseCase(UseCaseComposer c) {
  c
    ..description(
      'A component used do display a path.',
    )
    ..tags([Tags.display]);

  final path = c.knobs.string(
    'Path',
    initialValue: 'MyFolder/MyComponent/MyUseCase',
  );

  c
    ..knobPreset('Empty', () {
      path.value = '';
    })
    ..knobPreset('Single', () {
      path.value = 'MyUseCase';
    })
    ..knobPreset('Long', () {
      path.value = 'MyFolder/MySubFolder/MyComponent/MyUseCase';
    });
  return (context) {
    return WPathDisplay(
      nameSegments: path.value.split('/'),
    );
  };
}
