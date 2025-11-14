import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/werkbank.dart';

void main() {
  group('Accessors', () {
    final root = WerkbankRoot(
      children: [
        WerkbankUseCase(
          name: 'Empty',
          builder: (c) {
            return (context) => const SizedBox.shrink();
          },
        ),
      ],
    );
    final rootDescriptor = RootDescriptor.fromWerkbankRoot(root);
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

    testWidgets('WerkbankApp', (tester) async {
      await tester.pumpWidget(
        WerkbankApp(
          name: 'Test',
          logo: null,
          appConfig: appConfig,
          addonConfig: addonConfig,
          persistenceConfig: const PersistenceConfig.memory(),
          globalStateConfig: GlobalStateConfig(
            initializations: [
              GlobalStateInitialization<HistoryController>((c) {
                // Pretend like we have visited the use case
                // so that it is opened on startup.
                c.logDescriptorVisit(useCase);
              }),
            ],
            // The last visited use case is only restored
            // on warm starts.
            alwaysTreatLikeWarmStart: true,
          ),
          root: root,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(UseCase.key), findsOneWidget);
      // There is a future in hot_reload_effect_handler.dart that takes
      // a few seconds to complete. Not waiting here can lead to
      // test failures.
      await tester.pump(const Duration(seconds: 10));
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonAccessor(context);
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
          access.accessAllFromAddonAccessor(context);
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
    access.accessAllFromAddonAccessor(context);
    access.accessAllFromAddonControlSectionAccessor(context);
    access.accessAllFromUseCaseAccessor(context);
    return [];
  }

  @override
  List<InspectControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) {
    const access = InspectControlSection.access;
    access.accessAllFromAddonAccessor(context);
    access.accessAllFromAddonControlSectionAccessor(context);
    access.accessAllFromUseCaseAccessor(context);
    return [];
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    const access = SettingsControlSection.access;
    access.accessAllFromAddonAccessor(context);
    access.accessAllFromAddonControlSectionAccessor(context);
    return [];
  }

  @override
  AddonDescription? buildDescription(BuildContext context) {
    const access = AddonDescription.access;
    access.accessAllFromAddonAccessor(context);
    return null;
  }

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    const access = HomePageComponent.access;
    access.accessAllFromAddonAccessor(context);
    access.accessAllFromWerkbankAppOnlyAccessor(context);
    return [];
  }
}

extension on AddonAccessor {
  void accessAllFromAddonAccessor(BuildContext context) {
    final addons = addonsOf(context);
    addonByIdOf(context, addons.first.id);
    isAddonActiveOf(context, addons.first.id);
  }
}

extension on WerkbankAppOnlyAccessor {
  void accessAllFromWerkbankAppOnlyAccessor(BuildContext context) {
    final root = rootDescriptorOf(context);
    metadataMapOf(context);
    metadataForUseCaseOf(context, root.useCases.first);
    routerOf(context);
    navStateOf(context);
    readNavStateOf(context);
    werkbankNameOf(context);
    logoOf(context);
    lastUpdatedOf(context);
    historyOf(context);
    globalStateControllerOf<HistoryController>(context);
    final sub = subscribeToErrors(context, (_) {});
    unawaited(sub.cancel());
    addonSpecificationsOf(context);
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
    maybeGlobalStateControllerOf<HistoryController>(context);
    maybeAddonSpecificationsOf(context);
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
  void accessAllFromAddonControlSectionAccessor(BuildContext context) {}
}
