import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get iconButtonUseCase => WerkbankUseCase(
  name: 'IconButton',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.description(
    'An icon button that triggers an action when pressed.\n'
    '## Notable Werkbank Features:\n'
    '- The **default background** is **different** for the icon button '
    'than for the other uses cases in the "Components" folder. '
    'While the background **can always be overridden** for all use cases '
    'in the **"Settings" tab**, Each use case can define '
    'a **default background**. '
    'This can also be done for an **entire folder** and **overridden '
    'by a single use case** in it.',
  );
  c.tags([ExampleTags.button]);
  c.urls([
    'https://api.flutter.dev/flutter/material/IconButton-class.html',
    'https://m3.material.io/components/icon-buttons',
  ]);

  c.overview.maximumScale(1.5);

  c.background.named('Checkerboard');

  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);

  return (context) {
    return IconButton(
      onPressed: enabledKnob.value
          ? () {
              UseCase.dispatchTextNotification(context, 'onPressed');
            }
          : null,
      icon: Icon(
        semanticLabel: 'Semantic Label',
        Icons.search,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  };
}
