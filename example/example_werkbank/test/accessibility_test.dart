import 'package:example_werkbank/src/example_werkbank/addon_config.dart';
import 'package:example_werkbank/src/example_werkbank/app_config.dart';
import 'package:example_werkbank/src/example_werkbank/custom_metadata/testing_metadata.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/root.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/werkbank.dart';

void main() {
  group('Accessibility Tests', () {
    final rootDescriptor = RootDescriptor.fromWerkbankRoot(root);
    final useCases = rootDescriptor.useCases;
    const repaintBoundaryKey = Key('repaint-boundary');

    // Iterate over all use cases
    for (final useCase in useCases) {
      final metadata = useCase.computeMetadata(addonConfig);
      // Skip use cases that are excluded from testing.
      // This uses custom metadata that can be adjusted to your needs.
      if (!metadata.testing.include) {
        continue;
      }
      // Iterate over all knob presets for each use case
      for (final knobPreset in metadata.knobPresets) {
        final presetName = switch (knobPreset) {
          InitialKnobPreset() => null,
          DefinedKnobPreset() => '(${knobPreset.name})',
        };
        final testName = [
          useCase.nameSegments.join('/'),
          if (presetName != null) presetName,
        ].join(' ');
        // Test the use case with the respective knob preset
        testWidgets(testName, (WidgetTester tester) async {
          await tester.pumpWidget(
            RepaintBoundary(
              key: repaintBoundaryKey,
              child: DisplayApp.singleUseCase(
                appConfig: appConfig,
                addonConfig: addonConfig,
                useCase: useCase,
                initialMutation: (composition) {
                  composition.knobs.loadPreset(knobPreset);
                },
              ),
            ),
          );

          await tester.pumpAndSettle();
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));

          await expectLater(
            find.byKey(repaintBoundaryKey),
            matchesGoldenFile('goldens/$testName.png'),
          );
        });
      }
    }
  });
}
