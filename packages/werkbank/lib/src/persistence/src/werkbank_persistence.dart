import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PersistencePhaseWidgetBuilder =
    Widget Function(
      BuildContext context,
      WerkbankPersistencePhase phase,
    );

typedef ControllerMapFactory =
    Map<Type, PersistentController> Function(
      SharedPreferencesWithCache prefsWithCache,
    );

sealed class WerkbankPersistencePhase {
  const WerkbankPersistencePhase();
}

class PersistenceInitializing extends WerkbankPersistencePhase {}

class PersistenceReady extends WerkbankPersistencePhase {
  const PersistenceReady(this.child);

  final Widget child;
}

class WerkbankPersistence extends StatefulWidget {
  const WerkbankPersistence({
    required this.builder,
    required this.controllerMapFactory,
    required this.child,
    super.key,
  });

  final PersistencePhaseWidgetBuilder builder;
  final ControllerMapFactory controllerMapFactory;
  final Widget child;

  /// {@template werkbank.controller_available_in_app}
  /// If the current context is a Werkbank App, not
  /// a UseCaseDisplay, it is safe to assume that the
  /// controller is available.
  /// {@endtemplate}
  static HistoryController? maybeHistoryOf(BuildContext context) {
    return maybeControllerOf<HistoryController>(context);
  }

  /// {@macro werkbank.controller_available_in_app}
  static AcknowledgedController? maybeAcknowledgedController(
    BuildContext context,
  ) {
    return maybeControllerOf<AcknowledgedController>(context);
  }

  /// {@macro werkbank.controller_available_in_app}
  static PanelTabsController? maybePanelTabsController(BuildContext context) {
    return maybeControllerOf<PanelTabsController>(context);
  }

  /// {@macro werkbank.controller_available_in_app}
  static SearchQueryController? maybeSearchQueryController(
    BuildContext context,
  ) {
    return maybeControllerOf<SearchQueryController>(context);
  }

  /// {@macro werkbank.controller_available_in_app}
  static WasAliveController? maybeWasAliveController(
    BuildContext context,
  ) {
    return maybeControllerOf<WasAliveController>(context);
  }

  static T? maybeControllerOf<T extends PersistentController>(
    BuildContext context,
  ) {
    return _InheritedWerkbankPersistence.of(context)?.controllers[T] as T?;
  }

  @override
  State<WerkbankPersistence> createState() => _WerkbankPersistenceState();
}

class _WerkbankPersistenceState extends State<WerkbankPersistence> {
  late final SharedPreferencesWithCache _prefsWithCache;
  late final Map<Type, PersistentController> _controllers;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // WerkbankPersistence defers the first frame
    // until the Persistence is ready.
    // This way we avoid a jumping color effect when building the first
    // frames.
    RendererBinding.instance.deferFirstFrame();
    unawaited(_init());
  }

  Future<void> _init() async {
    await _initCache();
    await _initControllers();
    setState(() {
      _initialized = true;
      RendererBinding.instance.allowFirstFrame();
    });
  }

  Future<void> _initCache() async {
    _prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  Future<void> _initControllers() async {
    _controllers = widget.controllerMapFactory(_prefsWithCache);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return widget.builder(
        context,
        PersistenceInitializing(),
      );
    }

    return widget.builder(
      context,
      PersistenceReady(
        _InheritedWerkbankPersistence(
          controllers: _controllers,
          child: widget.child,
        ),
      ),
    );
  }
}

class _InheritedWerkbankPersistence extends InheritedWidget {
  const _InheritedWerkbankPersistence({
    required this.controllers,
    required super.child,
  });

  final Map<Type, PersistentController> controllers;

  static _InheritedWerkbankPersistence? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedWerkbankPersistence>();
  }

  @override
  bool updateShouldNotify(_InheritedWerkbankPersistence oldWidget) {
    return controllers != oldWidget.controllers;
  }
}
