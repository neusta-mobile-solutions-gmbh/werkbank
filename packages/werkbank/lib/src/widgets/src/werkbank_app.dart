import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Welcome}
/// {@category Get Started}
/// The main entry point for a Werkbank.
///
/// Minimal example:
/// ```dart
/// WerkbankApp(
///   name: 'Projekt Name',
///   logo: const YourLogo(),
///   appConfig: AppConfig.material(),
///   addonConfig: AddonConfig(addons: []),
///   sections: yourSections,
/// );
/// ```
class WerkbankApp extends StatelessWidget {
  const WerkbankApp({
    required this.name,
    required this.logo,
    this.lastUpdated,
    required this.appConfig,
    required this.addonConfig,
    required this.sections,
    super.key,
  });

  /// The name of your project that this [WerkbankApp] is for.
  final String name;

  /// The logo of your project that this [WerkbankApp] is for.
  final Widget? logo;

  /// {@category Get Started}
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

  /// The sections of the [WerkbankApp].
  /// This can be as simple as follows:
  /// ```dart
  /// WerkbankSections get sections => WerkbankSections(
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
  final WerkbankSections sections;

  RootDescriptor _getRootDescriptor(BuildContext context) {
    try {
      return RootDescriptor.fromWerkbankSections(sections);
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
      return RootDescriptor.fromWerkbankSections(
        WerkbankSections(
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
                  // sections are still identical.
                  // That way the controller manager will reassemble the
                  // controllers.
                  rootDescriptor: _getRootDescriptor(context),
                  child: _WerkbankPersistance(
                    addonConfig: addonConfig,
                    child: WerkbankSettings.overwrite(
                      orderOption: OrderOption.alphabetic,
                      werkbankTheme: WerkbankTheme(
                        colorScheme: WerkbankColorScheme.fromPalette(
                          const WerkbankPalette.dark(),
                        ),
                        textTheme: WerkbankTextTheme.standard(),
                      ),
                      child: PanelControllerProvider(
                        child: AddonConfigProvider(
                          addonConfig: addonConfig,
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
    required this.addonConfig,
    required this.child,
  });

  final AddonConfig addonConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final descendantsPaths = WerkbankAppInfo.rootDescriptorOf(
      context,
    ).descendants.map((e) => e.path).toSet();
    return WerkbankPersistence(
      controllerMapFactory: (prefsWithCache) {
        final wasAliveController = WasAliveController(
          prefsWithCache: prefsWithCache,
        );
        return {
          for (final addon in addonConfig.addons)
            ...addon.controllerMapFactory(prefsWithCache),
          HistoryController: HistoryControllerImpl(
            prefsWithCache: prefsWithCache,
          ),
          // Since this only gets executed once per app start,
          // hot-reload does not lead to a new path being added.
          // But this is fine.
          AcknowledgedController: AcknowledgedControllerImpl(
            prefsWithCache: prefsWithCache,
            /* TODO(lwiedekamp): Maybe improve this someday. Instead
                 add a method to update the descendantsPaths at runtime.
                 Maybe AcknowledgedTracker should call this method. */
            descendantsPaths: descendantsPaths,
          ),
          PanelTabsController: PanelTabsController(
            prefsWithCache: prefsWithCache,
          ),
          WasAliveController: wasAliveController,
          SearchQueryController: SearchQueryController(
            prefsWithCache: prefsWithCache,
            wasAliveController: wasAliveController,
          ),
        };
      },
      builder: (context, phase) => switch (phase) {
        PersistenceInitializing() =>
          // While initializing the Persistence, almost the whole werkbank
          // widget-tree will not be built and therefore there will be
          // no conflicts regarding the missing Persistence.
          //
          // But this widget (SizedBox) is never visible either, since
          // [WerkbankPersistence] defers the first frame until
          // the persistence is ready.
          // This way we avoid a jumping color effect when building the first
          // frames.
          const SizedBox.expand(),
        PersistenceReady(:final child) => child,
      },
      child: child,
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
