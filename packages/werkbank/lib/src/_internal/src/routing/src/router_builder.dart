import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/utils/utils.dart';
import 'package:werkbank/src/widgets/widgets.dart';

typedef RoutesWidgetBuilder =
    Widget Function(
      BuildContext context,
      GoRouter router,
    );

typedef ShellBuilder =
    ShellRoute Function(
      BuildContext context,
      List<RouteBase> routes,
    );

class RouterBuilder extends StatefulWidget {
  const RouterBuilder({
    required this.appBuilder,
    required this.mainPageBuilder,
    super.key,
  });

  final RoutesWidgetBuilder appBuilder;
  final WrapperBuilder mainPageBuilder;

  @override
  State<RouterBuilder> createState() => _RouterBuilderState();
}

class _RouterBuilderState extends State<RouterBuilder> {
  GoRouter? goRouter;
  ValueNotifier<RoutingConfig>? config;
  List<String>? prevPaths;

  void _updateRoutingConfig(List<RouteBase> routes) {
    if (config == null) {
      config = ValueNotifier<RoutingConfig>(
        RoutingConfig(
          routes: routes,
        ),
      );
    } else {
      config!.value = RoutingConfig(
        routes: routes,
      );
    }
  }

  void _maybeInitGoRouter({String? initialLocation}) {
    goRouter ??= GoRouter.routingConfig(
      routingConfig: config!,
      initialLocation: initialLocation ?? '/',
      onException: (context, state, router) {
        // This happens when the routes are swapped
        // and GoRouter tries to restore e.g. /artikel,
        // but this route no longer exists (loginRoutes).
        // In this case (404), it redirects to the default route
        // /.
        router.go('/');
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rootDescriptor = WerkbankAppInfo.rootDescriptorOf(context);

    final paths = rootDescriptor.descendants.map((e) => e.path).toList();
    final didPathChange = !const ListEquality<String>().equals(
      prevPaths,
      paths,
    );

    if (didPathChange) {
      _updateRouting(rootDescriptor);
    }
    prevPaths = paths;
  }

  void _updateRouting(RootDescriptor rootDescriptor) {
    final routes = [
      mainRoute(
        routes: [
          homeRoute(),
          descriptorRoute(rootDescriptor.pathSegments),
          for (final descriptor in rootDescriptor.descendants)
            descriptorRoute(descriptor.pathSegments),
        ],
        wrapperBuilder: widget.mainPageBuilder,
      ),
    ];

    _updateRoutingConfig(routes);

    final initialLocation = _maybeGetRecentDescriptorPath(rootDescriptor);
    _maybeInitGoRouter(initialLocation: initialLocation);
  }

  String? _maybeGetRecentDescriptorPath(RootDescriptor rootDescriptor) {
    if (goRouter != null) {
      // This is not a new appstart. The useCases have been updated,
      // goRouter will restore itself based on the previous routing-path.
      return null;
    }
    // This is a warm appstart.
    final isWarmStart = IsWarmStartProvider.read(context);

    if (!isWarmStart) {
      // The app was not recently alive, we don't want to restore
      // history that is too old.
      return null;
    }

    final mostRecentHistoryEntry = GlobalStateManager.maybeHistoryOf(
      context,
    )?.unsafeHistory.currentEntry;

    if (mostRecentHistoryEntry == null) {
      // There is no history, we can't restore anything.
      return null;
    }

    final entry = rootDescriptor.maybeFromPath(mostRecentHistoryEntry.path);
    final entryNoLongerExists = entry == null;

    if (entryNoLongerExists) {
      // The most recent history entry is no longer part of the app.
      return null;
    }

    return routePathForPathSegments(entry.pathSegments);
  }

  @override
  Widget build(BuildContext context) {
    return widget.appBuilder(
      context,
      goRouter!,
    );
  }
}
