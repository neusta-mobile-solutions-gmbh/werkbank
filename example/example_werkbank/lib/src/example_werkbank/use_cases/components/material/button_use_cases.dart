import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

enum _ButtonVariant {
  filled('FilledButton'),
  filledTonal('FilledButton.tonal'),
  outlined('OutlinedButton'),
  text('TextButton'),
  elevated('ElevatedButton');

  const _ButtonVariant(this.name);

  final String name;
}

WerkbankComponent get buttonComponent => WerkbankComponent(
  name: 'Button',
  useCases: [
    for (final variant in _ButtonVariant.values)
      WerkbankUseCase(
        name: variant.name,
        builder: (c) => _useCase(c, variant),
      ),
  ],
);

WidgetBuilder _useCase(UseCaseComposer c, _ButtonVariant variant) {
  c.description(
    'A button that triggers an action when pressed.\n'
    '## Notable Werkbank Features:\n'
    '- The different button types are grouped in a **component**. '
    'Components also group the contained use cases into a single tile in the '
    '**overview**.\n'
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
    final constructor = switch (variant) {
      _ButtonVariant.filled => FilledButton.new,
      _ButtonVariant.filledTonal => FilledButton.tonal,
      _ButtonVariant.outlined => OutlinedButton.new,
      _ButtonVariant.text => TextButton.new,
      _ButtonVariant.elevated => ElevatedButton.new,
    };
    return constructor(
      onPressed: enabledKnob.value
          ? () {
              UseCase.dispatchTextNotification(context, 'onPressed');
            }
          : null,
      child: Text(labelKnob.value),
    );
  };
}
