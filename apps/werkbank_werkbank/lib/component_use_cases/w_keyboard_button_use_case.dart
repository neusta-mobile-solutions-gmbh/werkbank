import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wKeyboardButtonUseCase(UseCaseComposer c) {
  c
    ..description(
      'A visual representation of a keyboard button.',
    )
    ..tags([Tags.display]);

  final text = c.knobs.string('content', initialValue: '⌘');

  return (context) {
    return WKeyboardButton(text: text.value);
  };
}
