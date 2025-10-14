import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/werkbank.dart';

// TODO: Partially AI generated. Check correctness.
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromWerkbankAppOnlyAccessor(context);
          return child;
        },
      ),
    ],
    useCaseOverlay: [
      UseCaseOverlayLayerEntry(
        id: 'useCaseOverlay',
        builder: (context, child) {
          const access = UseCaseOverlayLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromWerkbankAppOnlyAccessor(context);
          access.accessAllFromUseCaseAccessor(context);
          return child;
        },
      ),
    ],
    affiliationTransition: [
      AffiliationTransitionLayerEntry(
        id: 'affiliationTransition',
        builder: (context, child) {
          const access = AffiliationTransitionLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromMaybeWerkbankAppAccessor(context);
          return child;
        },
      ),
    ],
    useCase: [
      UseCaseLayerEntry(
        id: 'useCase',
        builder: (context, child) {
          const access = UseCaseLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromMaybeWerkbankAppAccessor(context);
          access.accessAllFromUseCaseAccessor(context);
          return child;
        },
      ),
    ],
    useCaseLayout: [
      UseCaseLayoutLayerEntry(
        id: 'useCaseLayout',
        builder: (context, child) {
          const access = UseCaseLayoutLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromMaybeWerkbankAppAccessor(context);
          access.accessAllFromUseCaseAccessor(context);
          access.maybeUseCaseViewportSizeOf(context);
          return child;
        },
      ),
    ],
    useCaseFitted: [
      UseCaseFittedLayerEntry(
        id: 'useCaseFitted',
        builder: (context, child) {
          const access = UseCaseFittedLayerEntry.access;
          access.accessAllFromAddonLayerAccessor(context);
          access.accessAllFromMaybeWerkbankAppAccessor(context);
          access.accessAllFromUseCaseAccessor(context);
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
    access.accessAllFromAddonControlSectionAccessor(context);
    return [];
  }

  @override
  List<InspectControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) {
    const access = InspectControlSection.access;
    access.accessAllFromAddonControlSectionAccessor(context);
    return [];
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    const access = SettingsControlSection.access;
    access.accessAllFromAddonControlSectionAccessor(context);
    return [];
  }

  @override
  AddonDescription? buildDescription(BuildContext context) {
    const access = AddonDescription.access;
    access.accessAllFromWerkbankAppOnlyAccessor(context);
    return null;
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    const access = HomePageComponent.access;
    access.accessAllFromAddonAccessor(context);
    return [];
  }
}

extension on AddonAccessor {
  void accessAllFromAddonAccessor(BuildContext context) {
    addonsOf(context);
  }
}

extension on WerkbankAppOnlyAccessor {
  void accessAllFromWerkbankAppOnlyAccessor(BuildContext context) {
    rootDescriptorOf(context);
    metadataMapOf(context);
    final descriptor = rootDescriptorOf(context).useCases.first;
    metadataForUseCaseOf(context, descriptor);
    routerOf(context);
    navStateOf(context);
    readNavStateOf(context);
    werkbankNameOf(context);
    logoOf(context);
    lastUpdatedOf(context);
    historyOf(context);
    acknowledgedController(context);
    persistentControllerOf<HistoryController>(context);
    final sub = subscribeToErrors(context, (_) {});
    unawaited(sub.cancel());
  }
}

extension on MaybeWerkbankAppAccessor {
  void accessAllFromMaybeWerkbankAppAccessor(BuildContext context) {
    final maybeRoot = maybeRootDescriptorOf(context);
    maybeMetadataMapOf(context);
    if (maybeRoot != null) {
      maybeMetadataForUseCaseOf(context, maybeRoot.useCases.first);
    }
    maybeRouterOf(context);
    maybeNavStateOf(context);
    maybeReadNavStateOf(context);
    maybeWerkbankNameOf(context);
    maybeLogoOf(context);
    maybeLastUpdatedOf(context);
    maybeHistoryOf(context);
    maybeAcknowledgedController(context);
    maybePersistentControllerOf<HistoryController>(context);
  }
}

extension on UseCaseAccessor {
  void accessAllFromUseCaseAccessor(BuildContext context) {
    useCaseOf(context);
    metadataOf(context);
    compositionOf(context);
    maybeUseCaseEnvironmentOf(context);
  }
}

extension on AddonLayerAccessor {
  void accessAllFromAddonLayerAccessor(BuildContext context) {
    environmentOf(context);
  }
}

extension on AddonControlSectionAccessor {
  void accessAllFromAddonControlSectionAccessor(BuildContext context) {
    addonsOf(context);
    rootDescriptorOf(context);
    metadataMapOf(context);
    routerOf(context);
    navStateOf(context);
  }
}
