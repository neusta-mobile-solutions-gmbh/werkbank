import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get checkboxUseCase => WerkbankUseCase(
  name: 'Checkbox',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.description(
    'A checkbox that allows to select a value.\n'
    '## Notable Werkbank Features:\n'
    '- **Knobs** adjust the checkbox state interactively.  '
    'Not only can the knobs affect the checkbox, but the **checkbox can also affect the knobs**.\n'
    '- **Knob presets** allow you to quickly set the checkbox state to common configurations.\n'
    '  - By clicking the small button left of the knob preset selector, '
    'you can visit an **overview** over all the **knob presets**. '
    'This allows you to see the checkbox in **all its possible states** at once. '
    'During development this would allow you to see the **effects of '
    'code changes** on multiple widgets states using at once after doing a **hot reload**.\n'
    '- The **overview thumbnail** of the checkbox is **bigger** than the checkbox '
    'normally would be. This highlights the **customizability** of the thumbnails.',
  );
  c.tags([ExampleTags.input]);
  c.urls([
    'https://api.flutter.dev/flutter/material/Checkbox-class.html',
    'https://m3.material.io/components/checkbox',
  ]);

  c.overview
    ..maximumScale(2)
    ..minimumSize(width: 40, height: 40);

  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);
  final tristateKnob = c.knobs.boolean('Tristate', initialValue: false);
  final valueKnob = c.knobs.nullable.boolean('Value', initialValue: true);

  for (final enabled in [true, false]) {
    for (final value in [false, true, null]) {
      c.knobPreset(
        '${enabled ? 'Enabled' : 'Disabled'}, $value',
        () {
          enabledKnob.value = enabled;
          valueKnob.value = value;
        },
      );
    }
  }

  return (context) {
    return Checkbox(
      semanticLabel: 'Semantic Label',
      tristate: tristateKnob.value || valueKnob.value == null,
      value: valueKnob.value,
      onChanged: enabledKnob.value
          ? (value) {
              valueKnob.value = value;
            }
          : null,
    );
  };
}
