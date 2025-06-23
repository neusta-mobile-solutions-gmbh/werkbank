import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/fidget_spinner_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/material/material.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/components/relaxation_card_use_cases.dart';

WerkbankFolder get componentsFolder => WerkbankFolder(
  name: 'Components',
  builder: (c) {
    c.background.named('Surface');
  },
  children: [
    materialFolder,
    fidgetSpinnerComponent,
    relaxationCardUseCase,
  ],
);
