import 'package:example_werkbank/src/example_app/components/date_picker_button.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankComponent get datePickerComponent => WerkbankComponent(
  name: 'Date Picker',
  useCases: [
    WerkbankUseCase(
      name: 'DatePickerButton',
      builder: _buttonUseCase,
    ),
    WerkbankUseCase(
      name: 'DatePickerDialog',
      builder: _dialogUseCase,
    ),
  ],
);

WidgetBuilder _buttonUseCase(UseCaseComposer c) {
  c.description(
    'A button that opens a date picker dialog to select a date.\n'
    '## Notable Werkbank Features:\n'
    '- The button is able to **open a route** within the use case **without '
    'interfering** with the router of the Werkbank itself. '
    'The widgets in the route are correctly **affected by theming**, etc.',
  );
  c.tags([ExampleTags.button]);

  c.overview.minimumSize(width: 150, height: 50);

  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);

  final dateKnob = c.knobs.date('Date', initialValue: DateTime.now());
  return (context) {
    return DatePickerButton(
      date: dateKnob.value,
      onDateSelected: enabledKnob.value
          ? (date) {
              dateKnob.value = date;
            }
          : null,
    );
  };
}

WidgetBuilder _dialogUseCase(UseCaseComposer c) {
  c.description(
    'A dialog to select a date.\n'
    '## Notable Werkbank Features:\n'
    '- The **overview thumbnail** of the date picker dialog is scaled down to '
    'fulfill a minimum size. '
    'This highlights the **customizability** of the thumbnails.\n'
    '- The selectable **constraints** are **limited to a minimum size**, '
    'since the  dialog is known to **overflow when smaller**.',
  );
  c.tags([ExampleTags.input]);

  // Materials implementation has too small tap targets.
  // There is nothing we can do about that.
  // So we have tp exclude it from testing in order for the tests to pass.
  c.testing.exclude();

  c.overview.minimumSize(width: 300, height: 500);
  c.constraints.supported(const BoxConstraints(minWidth: 250, minHeight: 450));

  return (context) {
    return MediaQuery(
      // The date pickers orientation depends on the device orientation.
      // To keep it consistent, we fake it.
      data: MediaQuery.of(context).copyWith(size: const Size(500, 500)),
      child: DatePickerDialog(
        firstDate: DateTime(0),
        lastDate: DateTime(3000),
      ),
    );
  };
}
