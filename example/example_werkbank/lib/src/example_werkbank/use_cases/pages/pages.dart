import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/pages/fidgets_page_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/pages/main_page_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/pages/profile_page_use_cases.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/pages/relaxation_page_use_cases.dart';

WerkbankFolder get pagesFolder => WerkbankFolder(
  name: 'Pages',
  builder: (c) {
    c.description('A page.');
    c.background.named('Checkerboard');
    c.constraints.devicePresets();
    c.overview
      ..minimumSize(width: 350, height: 350)
      ..withoutPadding();
    c.withSafeArea();
  },
  children: [
    fidgetsPageUseCase,
    relaxationPageUseCase,
    profilePageUseCase,
    mainPageUseCase,
  ],
);
