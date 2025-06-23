import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/werkbank.dart';

import 'data/dummy_addons.dart';
import 'data/dummy_sections.dart';

void main() {
  group('Display', () {
    final rootDescriptor = RootDescriptor.fromWerkbankSections(
      dummySections,
    );

    for (final useCases in rootDescriptor.useCases) {
      testWidgets(useCases.path, (WidgetTester tester) async {
        await tester.pumpWidget(
          DisplayApp.singleUseCase(
            appConfig: AppConfig.material(),
            addonConfig: dummyAddons,
            useCase: useCases,
          ),
        );
      });
    }
  });
}
