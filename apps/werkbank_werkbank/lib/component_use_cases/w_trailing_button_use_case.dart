import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wTrailingButtonUseCase(UseCaseComposer c) {
  c
    ..description(
      'A small button to put after a label or something similar.',
    )
    ..tags([Tags.button]);

  final isActive = c.knobs.boolean('Is Active', initialValue: false);
  final text = c.knobs.string('Text', initialValue: 'M3');

  return (context) {
    return WTrailingButton(
      onPressed: () => isActive.value = !isActive.value,
      isActive: isActive.value,
      child: Text(
        text.value,
      ),
    );
  };
}
