import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/_internal/src/routing/src/_internal/transitions/werkbank_page.dart';
import 'package:werkbank/src/werkbank_internal.dart';

const _descriptorPathSegment = 'view';

Descriptor? _descriptorFromUrl(BuildContext context, GoRouterState state) {
  final segments = state.uri.pathSegments;
  if (segments.isEmpty || segments.first != _descriptorPathSegment) {
    return null;
  }
  return WerkbankAppInfo.rootDescriptorOf(context).maybeFromPath(
    Uri(pathSegments: segments.sublist(1)).path,
  );
}

String routePathForPathSegments(List<String> pathSegments) {
  return '/${Uri(
    pathSegments: [
      _descriptorPathSegment,
      ...pathSegments,
    ],
  )}';
}

String _labelFromName(String name) {
  return name.split(':').first;
}

const _mainLabel = 'main';

ShellRoute mainRoute({
  required List<RouteBase> routes,
  required WrapperBuilder wrapperBuilder,
}) {
  return ShellRoute(
    pageBuilder:
        (
          context,
          state,
          child,
        ) {
          return NoTransitionPage<void>(
            key: const ValueKey(_mainLabel),
            child: Builder(
              builder: (context) {
                return wrapperBuilder(context, child);
              },
            ),
          );
        },
    routes: routes,
  );
}

const _homeLabel = 'home';

GoRoute homeRoute() {
  return GoRoute(
    path: '/',
    name: _homeLabel,
    pageBuilder: (context, state) => const WerkbankPage<void>(
      key: ValueKey(_homeLabel),
      child: HomePage(),
    ),
  );
}

const _descriptorLabel = 'descriptor';

GoRoute descriptorRoute(List<String> pathSegments) {
  final path = routePathForPathSegments(pathSegments);
  return GoRoute(
    path: path,
    name: '$_descriptorLabel:$path',
    pageBuilder: (context, state) {
      return WerkbankPage<void>(
        key: ValueKey(
          (
            _descriptorLabel,
            path,
            state.extra is UseCaseOverviewConfig,
          ),
        ),
        child: Builder(
          builder: (context) {
            final descriptor = _descriptorFromUrl(context, state);
            // This can happen when reloading with changed descriptors.
            if (descriptor == null) {
              return const SizedBox.expand();
            }
            final navState = _descriptorNavState(descriptor, state);
            switch (navState) {
              case OverviewNavState():
                return OverviewPage(navState: navState);
              case ViewUseCaseNavState():
                return UseCasePage(navState: navState);
            }
          },
        ),
      );
    },
  );
}

NavState getNavState(BuildContext context, GoRouterState state) {
  switch (_labelFromName(state.topRoute!.name!)) {
    case _homeLabel:
      return HomeNavState();
    case _descriptorLabel:
      final descriptor = _descriptorFromUrl(context, state);
      if (descriptor == null) {
        return HomeNavState();
      }
      return _descriptorNavState(descriptor, state);
  }
  throw StateError('Unknown route name: ${state.name}');
}

DescriptorNavState _descriptorNavState(
  Descriptor descriptor,
  GoRouterState state,
) {
  switch (descriptor) {
    case ParentDescriptor():
      return ParentOverviewNavState(descriptor: descriptor);
    case UseCaseDescriptor():
      final extra = state.extra;
      switch (extra) {
        case UseCaseOverviewConfig():
          return UseCaseOverviewNavState(
            descriptor: descriptor,
            config: extra,
          );
        case UseCaseStateMutation():
          return ViewUseCaseNavState(
            descriptor: descriptor,
            initialMutation: extra,
          );
        case _:
          return ViewUseCaseNavState(descriptor: descriptor);
      }
  }
}
