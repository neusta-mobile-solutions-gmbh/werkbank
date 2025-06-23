import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wBorderedBoxUseCase(UseCaseComposer c) {
  c
    ..description(
      'A box with an optionally rounded border. '
      'Using this instead of a DecoratedBox prevents some color bleeding '
      'issues where the border and the background overlap.',
    )
    ..tags([Tags.base]);

  final borderWidth = c.knobs.doubleSlider(
    'Border Width',
    initialValue: 2,
    max: 8,
  );
  final useBorderColor = c.knobs.boolean(
    'Use Border Color',
    initialValue: true,
  );
  final useBackgroundColor = c.knobs.boolean(
    'Use Background Color',
    initialValue: true,
  );

  c.background.color(Colors.green);
  return (context) {
    return WBorderedBox(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(8),
      ),
      borderColor: useBorderColor.value ? Colors.red : null,
      backgroundColor: useBackgroundColor.value ? Colors.blue : null,
      borderWidth: borderWidth.value,
      child: const SizedBox(
        width: 100,
        height: 100,
      ),
    );
  };
}
