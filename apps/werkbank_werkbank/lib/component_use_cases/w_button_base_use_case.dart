import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wButtonBaseUseCase(UseCaseComposer c) {
  c
    ..description(
      'A base component to make the development of button-like components '
      'easier.',
    )
    ..tags([Tags.button, Tags.base]);

  final isActive = c.knobs.boolean('Is Active', initialValue: false);
  final semanticActiveState = c.knobs.boolean(
    'Semantic Active State',
    initialValue: false,
  );
  final showBorder = c.knobs.boolean('Show Border', initialValue: true);

  return (context) {
    return WButtonBase(
      onPressed: () {
        UseCase.dispatchTextNotification(
          context,
          'Button pressed',
        );
      },
      isActive: isActive.value,
      semanticActiveState: semanticActiveState.value,
      showBorder: showBorder.value,
      child: const SizedBox(
        width: 32,
        height: 32,
      ),
    );
  };
}
