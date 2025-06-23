import 'package:werkbank/werkbank.dart';

import 'dummy_use_cases.dart';

WerkbankSections get dummySections => WerkbankSections(
  children: [
    WerkbankFolder(
      name: 'Dummy Folder',
      children: [
        WerkbankComponent(
          name: 'Dummy Component',
          useCases: [
            WerkbankUseCase(
              name: 'Dummy Use Case',
              builder: dummyUseCase,
            ),
          ],
        ),
      ],
    ),
  ],
);
