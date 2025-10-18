import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addon_config/addon_config.dart';
import 'package:werkbank/src/app_config/app_config.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/persistence/persistence.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/utils/utils.dart';
import 'package:werkbank/src/widgets/widgets.dart';

/// A widget that sets up the app for displaying use cases without the UI of a
/// [WerkbankApp]. Usually one or more [UseCaseDisplay] widgets as
/// descendants to display the use cases.
/// Alternatively, the convenience constructor [DisplayApp.singleUseCase]
/// can be used to display a single use case.
/// {@category Display}
/// {@category Testing with Use Cases}
class DisplayApp extends StatelessWidget {
  const DisplayApp({
    super.key,
    required this.appConfig,
    required this.addonConfig,
    this.persistenceConfig = const PersistenceConfig.memory(),
    this.globalStateConfig = const GlobalStateConfig(),
    required this.child,
  });

  /// A convenience constructor to create a [DisplayApp] with a
  /// [UseCaseDisplay] as child.
  ///
  /// The [appConfig], [addonConfig] and [persistenceConfig] parameters are
  /// passed to the [DisplayApp].
  /// The [useCase] and [initialMutation] parameters are passed to the
  /// [UseCaseDisplay].
  /// The [useCaseWrapper] parameter can be used to wrap the
  /// [UseCaseDisplay], effectively inserting a widget between it and the
  /// [DisplayApp].
  factory DisplayApp.singleUseCase({
    required AppConfig appConfig,
    required AddonConfig addonConfig,
    PersistenceConfig persistenceConfig = const PersistenceConfig.memory(),
    required UseCaseDescriptor useCase,
    UseCaseStateMutation? initialMutation,
    WrapperBuilder? useCaseWrapper,
  }) {
    final useCaseDisplay = UseCaseDisplay(
      useCase: useCase,
      initialMutation: initialMutation,
    );
    final Widget effectiveUseCaseDisplay;
    if (useCaseWrapper != null) {
      effectiveUseCaseDisplay = Builder(
        builder: (context) {
          return useCaseWrapper(
            context,
            useCaseDisplay,
          );
        },
      );
    } else {
      effectiveUseCaseDisplay = useCaseDisplay;
    }
    return DisplayApp(
      appConfig: appConfig,
      addonConfig: addonConfig,
      persistenceConfig: persistenceConfig,
      child: effectiveUseCaseDisplay,
    );
  }

  final AppConfig appConfig;
  final AddonConfig addonConfig;

  // TODO: Document
  final PersistenceConfig persistenceConfig;

  // TODO: Document
  final GlobalStateConfig globalStateConfig;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WerkbankEnvironmentProvider(
      environment: WerkbankEnvironment.display,
      child: AddonConfigProvider(
        addonConfig: addonConfig,
        child: JsonStoreProvider(
          persistenceConfig: persistenceConfig,
          placeholder: const SizedBox.expand(),
          child: IsWarmStartProvider(
            child: GlobalStateManager(
              globalStateConfig: globalStateConfig,
              registerWerkbankGlobalStateControllers: (registry) {},
              // Technically we currently don't need a DescriptorProvider with
              // null descriptor here, but changes to what can be accessed in
              // which layer may change this in the future, so we keep it as
              // a safe guard.
              child: DescriptorProvider(
                descriptor: null,
                child: AddonLayerBuilder(
                  layer: AddonLayer.management,
                  child: UseCaseApp(
                    appConfig: appConfig,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
