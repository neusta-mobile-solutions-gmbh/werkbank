import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get sliderUseCase => WerkbankUseCase(
  name: 'Slider',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.description(
    'A slider that allows to select a value from a range.\n'
    '## Notable Werkbank Features:\n'
    '- The **initial constraints** of the silder default to '
    'a width defined in the code. '
    'This can always be changed in the UI though.\n'
    '- The slider also defines a **constraints preset** with a '
    '**different width** which can be selected from a dropdown.\n'
    '- A **nullable knob** is used for the silders division. '
    'Almost **all knobs** have a **nullable variant**. ',
  );
  c.tags([ExampleTags.input, ExampleTags.slider]);
  c.urls([
    'https://api.flutter.dev/flutter/material/Slider-class.html',
    'https://m3.material.io/components/sliders',
  ]);

  c.overview.minimumSize(width: 150, height: 50);

  c.constraints.initial(width: 200);
  c.constraints.preset('Wide', width: 400);

  final enabledKnob = c.knobs.boolean(
    'Enabled',
    initialValue: true,
  );

  final valueKnob = c.knobs.doubleSlider(
    'Value',
    initialValue: 0.5,
  );

  final divisionsKnob = c.knobs.nullable.intSlider(
    'Divisions',
    min: 1,
    initialValue: 10,
    initiallyNull: true,
  );

  c.knobPreset('Divided', () {
    divisionsKnob.value = 10;
  });

  return (context) {
    return Slider(
      value: valueKnob.value,
      divisions: divisionsKnob.value,
      onChanged: enabledKnob.value ? (value) => valueKnob.value = value : null,
    );
  };
}
