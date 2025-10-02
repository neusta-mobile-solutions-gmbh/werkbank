import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/routing/src/nav_state.dart';

class NavEventProvider extends StatefulWidget {
  const NavEventProvider({super.key, required this.child});

  final Widget child;

  static Stream<NavigationEvent> of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_Inherited>();
    assert(inherited != null, 'No NavEventProvider found in context');
    return inherited!.controller.stream;
  }

  @override
  State<NavEventProvider> createState() => _NavEventProviderState();
}

class _NavEventProviderState extends State<NavEventProvider> {
  late final NavigationEventController controller;

  @override
  void initState() {
    super.initState();
    controller = NavigationEventController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final navState = NavStateProvider.of(context);
    switch (navState) {
      case HomeNavState():
      case ParentOverviewNavState():
      case UseCaseOverviewNavState():
        return;
      case ViewUseCaseNavState(:final descriptor):
        controller.notifyNavigationEvent(
          NavigationEvent(descriptor.path, descriptor.pathSegments),
        );
    }
  }

  @override
  Future<void> dispose() async {
    await controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Inherited(controller: controller, child: widget.child);
  }
}

class _Inherited extends InheritedWidget {
  const _Inherited({
    required this.controller,
    required super.child,
  });

  final NavigationEventController controller;

  @override
  bool updateShouldNotify(covariant _Inherited oldWidget) {
    return controller != oldWidget.controller;
  }
}

class NavigationEventController {
  NavigationEventController() {
    _streamController = StreamController<NavigationEvent>.broadcast();
  }

  late final StreamController<NavigationEvent> _streamController;
  Stream<NavigationEvent> get stream => _streamController.stream;

  void notifyNavigationEvent(NavigationEvent event) {
    _streamController.add(event);
  }

  Future<void> dispose() async {
    await _streamController.close();
  }
}

class NavigationEvent {
  NavigationEvent(this.path, this.pathSegments);

  final String path;
  final List<String> pathSegments;
}
