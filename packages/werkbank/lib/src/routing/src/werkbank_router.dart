/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/routing/routing.dart';

//
/// A Proxy Router for the [WerkbankApp] since we don't want to
/// expose GoRouter
class WerkbankRouter {
  WerkbankRouter._(this._goRouter);

  /* TODO(lzuttermeister): This constructor should be hidden from public use.
       Addon authors should use the accessors instead. */
  factory WerkbankRouter.of(BuildContext context) {
    return WerkbankRouter._(GoRouter.of(context));
  }

  /* TODO(lzuttermeister): This constructor should be hidden from public use.
       Addon authors should use the accessors instead. */
  static WerkbankRouter? maybeOf(BuildContext context) {
    final goRouter = GoRouter.maybeOf(context);
    if (goRouter == null) {
      return null;
    }
    return WerkbankRouter._(goRouter);
  }

  final GoRouter _goRouter;

  void goTo(NavState navState) {
    switch (navState) {
      case HomeNavState():
        _goRouter.go('/');
      case ParentOverviewNavState(descriptor: final descriptor):
        _goRouter.go(routePathForPathSegments(descriptor.pathSegments));
      case UseCaseOverviewNavState(
        descriptor: final descriptor,
        :final config,
      ):
        _goRouter.go(
          routePathForPathSegments(descriptor.pathSegments),
          extra: config,
        );
      case ViewUseCaseNavState(:final descriptor, :final initialMutation):
        _goRouter.go(
          routePathForPathSegments(descriptor.pathSegments),
          extra: initialMutation,
        );
    }
  }
}
