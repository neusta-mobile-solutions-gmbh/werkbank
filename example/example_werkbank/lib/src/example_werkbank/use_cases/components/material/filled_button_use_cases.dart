import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get filledButtonUseCase => WerkbankUseCase(
  name: 'FilledButton',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.description(
    'A button that triggers an action when pressed.\n'
    '## Notable Werkbank Features:\n'
    '- **When pressed**, the button dispatches a **notification** '
    'visibile in the bottom right corner. '
    'This can be useful to make sure your `onPressed` callbacks are working.',
  );
  c.tags([ExampleTags.button]);
  c.urls([
    'https://api.flutter.dev/flutter/material/FilledButton-class.html',
    'https://m3.material.io/components/all-buttons',
  ]);

  c.overview.minimumSize(width: 150, height: 50);

  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);
  final labelKnob = c.knobs.string('Label', initialValue: 'Label Text');

  return (context) {
    return FilledButton(
      onPressed: enabledKnob.value
          ? () {
              UseCase.dispatchTextNotification(context, 'onPressed');
            }
          : null,
      child: Text(labelKnob.value),
    );
  };
}
