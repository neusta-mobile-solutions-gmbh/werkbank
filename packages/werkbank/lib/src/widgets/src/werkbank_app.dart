import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/_internal/src/filter/filter.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addon_config/addon_config.dart';
import 'package:werkbank/src/app_config/app_config.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/notifications/notifications.dart';
import 'package:werkbank/src/persistence/persistence.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/utils/utils.dart';
import 'package:werkbank/src/widgets/widgets.dart';

/// {@category Welcome}
/// {@category Getting Started}
/// The main entry point for a Werkbank.
///
/// Minimal example:
/// ```dart
/// WerkbankApp(
///   name: 'Projekt Name',
///   logo: const YourLogo(),
///   appConfig: AppConfig.material(),
///   addonConfig: AddonConfig(addons: []),
///   // The root of your use case tree.
///   root: root,
/// );
/// ```
class WerkbankApp extends StatelessWidget {
  const WerkbankApp({
    required this.name,
    required this.logo,
    this.lastUpdated,
    required this.appConfig,
    required this.addonConfig,
    this.persistenceConfig = const PersistenceConfig(),
    required this.root,
    super.key,
  });

  /// The name of your project that this [WerkbankApp] is for.
  final String name;

  /// The logo of your project that this [WerkbankApp] is for.
  final Widget? logo;

  /// {@category Getting Started}
  /// The date when the data was last updated.
  ///
  /// If you are deploying the werkbank with a CI, you can set this
  /// using an environment variable with an ISO 8601 date of the build time.
  /// For example like this:
  /// ```dart
  /// const lastUpdatedDate = String.fromEnvironment('last_updated_date');
  /// return WerkbankApp(
  ///   // ...
  ///   lastUpdated: lastUpdatedDate.isEmpty
  ///     ? DateTime.now()
  ///     : DateTime.parse(lastUpdatedDate),
  ///   // ...
  /// );
  /// ```
  final DateTime? lastUpdated;

  /// The [AppConfig] used for the use cases.
  ///
  /// This defines how the app widget is built, which is typically one of
  /// [MaterialApp], [CupertinoApp], or [WidgetsApp].
  /// The [AppConfig]s for these can be created using
  /// [AppConfig.material], [AppConfig.cupertino] and [AppConfig.widgets]
  /// respectively.
  /// For custom app widgets, use the default [AppConfig] constructor or create
  /// a custom implementation of [AppConfig].
  final AppConfig appConfig;

  /// The [AddonConfig] to be used by the [WerkbankApp].
  ///
  /// Usually this can be set as follows:
  /// ```dart
  /// addons: AddonConfig(
  ///   addons: [
  ///     ThemingAddon(/* options for your theming */),
  ///     // More addons here.
  ///   ],
  /// ),
  /// ```
  final AddonConfig addonConfig;

  // TODO: Document
  final PersistenceConfig persistenceConfig;

  /// The root of the use case tree.
  ///
  /// This can be as simple as follows:
  /// ```dart
  /// WerkbankRoot get root => WerkbankRoot(
  ///   children: [
  ///     WerkbankFolder(
  ///       name: 'My Folder',
  ///       children: [
  ///         WerkbankUseCase(
  ///           name: 'Some Use Case',
  ///           builder: someUseCase,
  ///         ),
  ///         // ...
  ///       ],
  ///     ),
  ///     // Or even just usecases
  ///     WerkbankUseCase(
  ///       name: 'Some Other Use Case',
  ///       builder: someOtherUseCase,
  ///     ),
  ///     // ...
  ///   ],
  /// );
  /// ```
  ///
  /// Please note that using a getter is mandatory,
  /// for the hot reload to work properly.
  final WerkbankRoot root;

  RootDescriptor _getRootDescriptor(BuildContext context) {
    try {
      return RootDescriptor.fromWerkbankRoot(root);
    } on DuplicateDescriptorPathsException catch (e, stackTrace) {
      final duplicatePaths = e.duplicatePaths;
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);

      UseCase.dispatchNotification(
        context,
        WerkbankNotification.widgets(
          key: const ValueKey('duplicatePathError'),
          buildHead: (context) => Text(
            context.sL10n.app.duplicatePathErrorTitleMessage,
            overflow: TextOverflow.ellipsis,
          ),
          buildBody: (context) => SizedBox(
            child: WMarkdown(
              data: context.sL10n.app.duplicatePathErrorContentMessageMarkdown(
                duplicatePath: [
                  for (final pathSegments in duplicatePaths)
                    '- ${pathSegments.join('/')}',
                ].join('\n'),
              ),
            ),
          ),
          dismissAfter: null,
        ),
        count: false,
      );
      return RootDescriptor.fromWerkbankRoot(
        WerkbankRoot(
          children: [],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WerkbankEnvironmentProvider(
      environment: WerkbankEnvironment.app,
      child: FlutterErrorProvider(
        child: WebFixer(
          child: WerkbankNotifications(
            child: Builder(
              builder: (context) {
                return WerkbankAppInfo(
                  name: name,
                  logo: logo,
                  lastUpdated: lastUpdated,
                  appConfig: appConfig,
                  // It is important that the root descriptor is computed
                  // here in a build methods, since when a reassembly happens
                  // we need to re-compute the root descriptor even if the
                  // WerkbankRoots are still identical.
                  // That way the controller manager will reassemble the
                  // controllers.
                  rootDescriptor: _getRootDescriptor(context),
                  child: AddonConfigProvider(
                    addonConfig: addonConfig,
                    child: _WerkbankPersistance(
                      persistenceConfig: persistenceConfig,
                      child: WerkbankSettings.overwrite(
                        orderOption: OrderOption.alphabetic,
                        werkbankTheme: WerkbankTheme(
                          colorScheme: WerkbankColorScheme.fromPalette(
                            const WerkbankPalette.dark(),
                          ),
                          textTheme: WerkbankTextTheme.standard(),
                        ),
                        child: PanelControllerProvider(
                          child: UseCaseMetadataProvider(
                            child: AddonLayerBuilder(
                              layer: AddonLayer.management,
                              child: RootDescriptorFilter(
                                child: RouterBuilder(
                                  appBuilder: (context, goRouter) =>
                                      _MaterialApp(
                                        goRouter: goRouter,
                                        builder: (context, child) {
                                          return AddonSpecificationsProvider(
                                            child: child,
                                          );
                                        },
                                      ),
                                  mainPageBuilder: (context, child) {
                                    return MainPage(
                                      mainView: child,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

typedef ThemedWidgetBuilder =
    Widget Function(
      BuildContext context,
      ThemeData theme,
    );

class _ThemeBuilder extends StatelessWidget {
  const _ThemeBuilder({
    required this.werkbankTheme,
    required this.builder,
  });

  final WerkbankTheme? werkbankTheme;
  final ThemedWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final effectiveWerkbankTheme =
        werkbankTheme ??
        WerkbankTheme(
          colorScheme: WerkbankColorScheme.fromPalette(
            const WerkbankPalette.light(),
          ),
          textTheme: WerkbankTextTheme.standard(),
        );
    final theme = getThemeData(context, effectiveWerkbankTheme);
    return builder(context, theme);
  }
}

class _WerkbankPersistance extends StatelessWidget {
  const _WerkbankPersistance({
    required this.persistenceConfig,
    required this.child,
  });

  final PersistenceConfig persistenceConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final descendantsPaths = WerkbankAppInfo.rootDescriptorOf(
      context,
    ).descendants.map((e) => e.path).toSet();
    return JsonStoreProvider(
      persistenceConfig: persistenceConfig,
      placeholder: const SizedBox.expand(),
      child: IsWarmStartProvider(
        child: WerkbankPersistence(
          persistenceConfig: persistenceConfig,
          registerWerkbankPersistentControllers: (registry) {
            registry.register<HistoryController>(
              'history',
              HistoryControllerImpl.new,
            );
            // TODO: Fix this
            // Since this only gets executed once per app start,
            // hot-reload does not lead to a new path being added.
            // But this is fine.
            registry.register<AcknowledgedController>(
              'acknowledged',
              () => AcknowledgedControllerImpl(
                // TODO: Fix this
                /* TODO(lwiedekamp): Maybe improve this someday. Instead
                     add a method to update the descendantsPaths at runtime.
                     Maybe AcknowledgedTracker should call this method. */
                descendantsPaths: descendantsPaths,
              ),
            );
            registry.register('pane_tabs', PanelTabsController.new);
            registry.register(
              'search_query',
              SearchQueryController.new,
            );
          },
          child: child,
        ),
      ),
    );
  }
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp({
    required this.goRouter,
    required this.builder,
  });

  final GoRouter goRouter;
  final WrapperBuilder builder;

  @override
  Widget build(BuildContext context) {
    final werkbankTheme = WerkbankSettings.werkbankThemeOf(context);
    return _ThemeBuilder(
      werkbankTheme: werkbankTheme,
      builder: (context, theme) {
        return MaterialApp.router(
          theme: theme.copyWith(
            // on a hot restart, goRouter will use this TransitionsTheme
            // to restore the current page. I dont what this to use the
            // default transitions, therefore I use
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                for (final p in TargetPlatform.values)
                  p: const FadeThroughPageTransitionsBuilder(),
              },
            ),
          ),
          localizationsDelegates: [
            WerkbankLocalizations.delegate,
            for (final addon in AddonConfigProvider.addonsOf(context))
              ...addon.buildLocalizationsDelegates(context),
          ],
          title: WerkbankAppInfo.nameOf(context),
          debugShowCheckedModeBanner: false,
          builder: (context, child) => builder(
            context,
            child ?? const SizedBox.expand(),
          ),
          routerConfig: goRouter,
        );
      },
    );
  }
}
