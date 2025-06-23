import 'package:example_werkbank/src/example_werkbank/use_cases/components/components.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/pages/pages.dart';
import 'package:werkbank/werkbank.dart';

WerkbankSections get sections => WerkbankSections(
  children: [
    componentsFolder,
    pagesFolder,
  ],
);
