import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankUseCase get textFieldUseCase => WerkbankUseCase(
  name: 'TextField',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  c.description(
    'A text field that allows to enter text.\n'
    '## Notable Werkbank Features:\n'
    '- The text field uses a special **focus node knob** that synchronizes the '
    'focus state of the text field with the knob.\n',
  );
  c.tags([ExampleTags.input]);
  c.urls([
    'https://api.flutter.dev/flutter/material/TextField-class.html',
    'https://m3.material.io/components/text-fields',
  ]);

  c.overview.minimumSize(width: 180);
  c.constraints.overview(width: 180);

  c.constraints.initial(width: 250);

  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);
  final labelKnob = c.knobs.string('Label', initialValue: 'Label Text');
  final focusNodeKnob = c.knobs.focusNode('Focus');

  return (context) {
    return TextField(
      enabled: enabledKnob.value,
      decoration: InputDecoration(
        labelText: labelKnob.value,
        border: const OutlineInputBorder(),
      ),
      focusNode: focusNodeKnob.value,
    );
  };
}
