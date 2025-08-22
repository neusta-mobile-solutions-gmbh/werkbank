import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get switchUseCase => WerkbankUseCase(
  name: 'Switch',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.description(
    'A switch that can be toggled.',
  );
  c.tags([ExampleTags.input]);
  c.urls([
    'https://api.flutter.dev/flutter/material/Switch-class.html',
    'https://m3.material.io/components/switche',
  ]);

  c.overview
    ..maximumScale(1.5)
    ..minimumSize(width: 80, height: 50);

  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);
  final valueKnob = c.knobs.boolean('Value', initialValue: true);

  for (final enabled in [true, false]) {
    for (final value in [false, true]) {
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
    return Semantics(
      label: 'Semantics Label',
      child: Switch(
        value: valueKnob.value,
        onChanged: enabledKnob.value
            ? (value) {
                valueKnob.value = value;
              }
            : null,
      ),
    );
  };
}
