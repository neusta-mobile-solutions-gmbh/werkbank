import 'package:example_werkbank/src/example_werkbank/use_cases/components/components.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/pages/pages.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/theme_use_cases.dart';
import 'package:werkbank/werkbank.dart';

WerkbankRoot get root => WerkbankRoot(
  children: [
    componentsFolder,
    pagesFolder,
    themeFolder,
  ],
);
