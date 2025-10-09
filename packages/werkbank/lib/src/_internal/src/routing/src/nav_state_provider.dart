import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/routing/routing.dart';

class NavStateProvider extends StatefulWidget {
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

  static Stream<NavState>? maybeEventStreamOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_NavEventStreamProvider>()
        ?.stream;
  }

  static Stream<NavState> eventStreamOf(BuildContext context) {
    final stream = maybeEventStreamOf(context);
    assert(stream != null, 'No NavStateProvider found in context');
    return stream!;
  }

  final Widget child;

  @override
  State<NavStateProvider> createState() => _NavStateProviderState();
}

class _NavStateProviderState extends State<NavStateProvider> {
  NavState? _navState;
  final StreamController<NavState> _streamController =
      StreamController<NavState>.broadcast();
  late final _stream = _streamController.stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newNavState = getNavState(context, GoRouterState.of(context));
    if (newNavState != _navState) {
      setState(() {
        _navState = newNavState;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // We have to fire this event in a post frame callback.
        // Other widgets may transform the stream using for example `.map`
        // and also react to changes of the NavState because of a dependency
        // from `NavStateProvider.of(context)`.
        // When such a widget rebuilds, the `.map` method is executed again and
        // a new stream is created.
        // However, without this post frame callback, the event has already been
        // fired, but the listeners have not yet triggered, because there was no
        // async gap yet.
        // The new mapped stream does not contain the event.
        // If a widget subscribes to the mapped stream, it also has to cancel
        // the old subscription when it changes and subscribe to the new one.
        // But this happens before the listeners have fired.
        // So the subscription would be closed before the listener has fired
        // and the new subscription would be made on a new stream that does
        // not contain the event.
        _streamController.add(newNavState);
      });
    }
  }

  @override
  void dispose() {
    unawaited(_streamController.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _NavStateScope(
      navState: _navState!,
      child: _NavEventStreamProvider(
        stream: _stream,
        child: widget.child,
      ),
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

class _NavEventStreamProvider extends InheritedWidget {
  const _NavEventStreamProvider({
    required this.stream,
    required super.child,
  });

  final Stream<NavState> stream;

  @override
  bool updateShouldNotify(_NavEventStreamProvider oldWidget) {
    return stream != oldWidget.stream;
  }
}
