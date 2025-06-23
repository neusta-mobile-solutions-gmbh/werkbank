import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/_internal/src/routing/src/_internal/routes.dart';
import 'package:werkbank/werkbank.dart';

class NavStateProvider extends StatelessWidget {
  const NavStateProvider({
    super.key,
    required this.child,
  });

  static NavState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_NavStateScope>()
        ?.navState;
  }

  static NavState of(BuildContext context) {
    final navState = maybeOf(context);
    assert(navState != null, 'No NavStateProvider found in context');
    return navState!;
  }

  static NavState? maybeReadOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<_NavStateScope>()?.navState;
  }

  static NavState readOf(BuildContext context) {
    final navState = maybeReadOf(context);
    assert(navState != null, 'No NavStateProvider found in context');
    return navState!;
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _NavStateScope(
      navState: getNavState(context, GoRouterState.of(context)),
      child: child,
    );
  }
}

class _NavStateScope extends InheritedWidget {
  const _NavStateScope({
    required this.navState,
    required super.child,
  });

  final NavState navState;

  @override
  bool updateShouldNotify(_NavStateScope oldWidget) {
    return navState != oldWidget.navState;
  }
}
