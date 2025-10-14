import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/werkbank.dart';

void main() {
  group('Accessors', () {
    final rootDescriptor = RootDescriptor.fromWerkbankRoot(
      WerkbankRoot(
        children: [
          WerkbankUseCase(
            name: 'Empty',
            builder: (c) {
              return (context) => const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
    final useCase = rootDescriptor.useCases.first;
    final addonConfig = AddonConfig(
      addons: [
        const _AccessorTestAddon(),
      ],
    );
    final appConfig = AppConfig.material();

    testWidgets('DisplayApp', (tester) async {
      await tester.pumpWidget(
        DisplayApp.singleUseCase(
          appConfig: appConfig,
          addonConfig: addonConfig,
          useCase: useCase,
        ),
      );
      expect(find.byKey(UseCase.key), findsOneWidget);
    });
  });
}

class _AccessorTestAddon extends Addon {
  const _AccessorTestAddon() : super(id: 'accessor_test');

  @override
  AddonLayerEntries get layers => AddonLayerEntries(
    management: [
      ManagementLayerEntry(
        id: 'management',
        builder: (context, child) {
          const access = ManagementLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          return child;
        },
      ),
    ],
    applicationOverlay: [
      ApplicationOverlayLayerEntry(
        id: 'applicationOverlay',
        builder: (context, child) {
          const access = ApplicationOverlayLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromWerkbankAppOnlyAccessor(context);
          return child;
        },
      ),
    ],
    mainViewOverlay: [
      MainViewOverlayLayerEntry(
        id: 'mainViewOverlay',
        builder: (context, child) {
          const access = MainViewOverlayLayerEntry.access;
          // TODO
          return child;
        },
      ),
    ],
    useCaseOverlay: [
      UseCaseOverlayLayerEntry(
        id: 'useCaseOverlay',
        builder: (context, child) {
          const access = UseCaseOverlayLayerEntry.access;
          // TODO
          return child;
        },
      ),
    ],
    affiliationTransition: [
      AffiliationTransitionLayerEntry(
        id: 'affiliationTransition',
        builder: (context, child) {
          const access = AffiliationTransitionLayerEntry.access;
          // TODO
          return child;
        },
      ),
    ],
    useCase: [
      UseCaseLayerEntry(
        id: 'useCase',
        builder: (context, child) {
          const access = UseCaseLayerEntry.access;
          // TODO
          return child;
        },
      ),
    ],
    useCaseLayout: [
      UseCaseLayoutLayerEntry(
        id: 'useCaseLayout',
        builder: (context, child) {
          const access = UseCaseLayoutLayerEntry.access;
          // TODO
          return child;
        },
      ),
    ],
    useCaseFitted: [
      UseCaseFittedLayerEntry(
        id: 'useCaseFitted',
        builder: (context, child) {
          const access = UseCaseFittedLayerEntry.access;
          // TODO
          return child;
        },
      ),
    ],
  );

  @override
  List<ConfigureControlSection> buildConfigureTabControlSections(
    BuildContext context,
  ) {
    const access = ConfigureControlSection.access;
    // TODO
    return [];
  }

  @override
  List<InspectControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) {
    const access = InspectControlSection.access;
    // TODO
    return [];
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    const access = SettingsControlSection.access;
    // TODO
    return [];
  }

  @override
  AddonDescription? buildDescription(BuildContext context) {
    const access = AddonDescription.access;
    // TODO
    return null;
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    const access = HomePageComponent.access;
    // TODO
    return [];
  }
}

extension on AddonLayerAccessor {
  void accessAllFromAddonLayerAccessor(BuildContext context) {
    environmentOf(context);
    addonsOf(context);
  }
}

extension on WerkbankAppOnlyAccessor {
  void accessAllFromWerkbankAppOnlyAccessor(BuildContext context) {
    rootDescriptorOf(context);
    metadataMapOf(context);
    // TODO: Add remaining.
  }
}
