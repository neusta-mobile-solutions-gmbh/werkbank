import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/checkbox_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/date_picker_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/filled_button_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/icon_button_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/slider_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/switch_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/text_field_use_cases.dart';

WerkbankFolder get materialFolder => WerkbankFolder(
  name: 'Material',
  builder: (c) {
    c.description('A component from the Material Design library.');
  },
  children: [
    checkboxUseCase,
    datePickerComponent,
    filledButtonUseCase,
    iconButtonUseCase,
    sliderUseCase,
    switchUseCase,
    textFieldUseCase,
  ],
);
