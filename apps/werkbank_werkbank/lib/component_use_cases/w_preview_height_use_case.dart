import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

const _loremIpsum = '''
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
''';

WidgetBuilder wCollapsableHeightUseCase(UseCaseComposer c) {
  c
    ..description(
      'By using a `WCollapsableHeight`, you can '
      'create a widget that can be expanded to its '
      'intrinsic height or collapsed to a fixed height. ',
    )
    ..tags([Tags.feature]);

  final collapsedHeight = c.knobs.doubleSlider(
    'collapsedHeight',
    initialValue: 200,
    min: 50,
    max: 400,
  );

  final actualHeight = c.knobs.doubleSlider(
    'actualHeight',
    initialValue: 600,
    min: 100,
    max: 600,
  );

  return (context) {
    return WCollapsableHeight(
      collapsedHeight: collapsedHeight.value,
      child: GestureDetector(
        onTap: () {
          UseCase.dispatchTextNotification(context, 'Card tapped');
        },
        child: Container(
          color: context.werkbankColorScheme.field,
          height: actualHeight.value,
          padding: const EdgeInsets.all(16),
          child: Text(_loremIpsum * 4),
        ),
      ),
    );
  };
}
