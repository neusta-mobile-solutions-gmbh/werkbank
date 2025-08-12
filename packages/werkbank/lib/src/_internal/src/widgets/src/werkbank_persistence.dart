import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werkbank/src/persistence/src/persistent_controller_registry.dart';
import 'package:werkbank/src/werkbank_internal.dart';

typedef ControllerMapFactory =
    Map<Type, PersistentController> Function(
      SharedPreferencesWithCache prefsWithCache,
    );

class WerkbankPersistence extends StatefulWidget {
  const WerkbankPersistence({
    required this.persistenceConfig,
    required this.persistentControllers,
    required this.placeholder,
    required this.child,
    super.key,
  });

  final PersistenceConfig persistenceConfig;
  final List<PersistentController> persistentControllers;
  final Widget placeholder;
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

  static T? maybeControllerOf<T extends PersistentController<T>>(
    BuildContext context,
  ) {
    return _InheritedWerkbankPersistence.of(context)?.controllersByType[T]
        as T?;
  }

  @override
  State<WerkbankPersistence> createState() => _WerkbankPersistenceState();
}

class _WerkbankPersistenceState extends State<WerkbankPersistence> {
  Map<Type, PersistentController>? _controllersByType;

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

  void _updateControllers() {
    void update() {
      _controllersByType = {
        for (final controller in widget.persistentControllers)
          controller.type: controller,
      };
    }

    final controllers = _controllersByType;
    if (controllers != null) {
      final jsonSnapshots = {
        for (final controller in controllers.values)
          controller.type: controller.toJson(),
      };
      for (final controller in controllers.values) {
        controller.dispose();
      }
      update();
      for (final controller in _controllersByType!.values) {
        final json = jsonSnapshots[controller.type];
        controller.tryLoadFromJson(json);
      }
    } else {
      update();
    }
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
    _controllersByType = widget.persistentControllers(_prefsWithCache);
  }

  @override
  void dispose() {
    for (final controller in _controllersByType.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return widget.placeholder;
    }

    return _InheritedWerkbankPersistence(
      controllersByType: _controllersByType,
      child: widget.child,
    );
  }
}

class _InheritedWerkbankPersistence extends InheritedWidget {
  const _InheritedWerkbankPersistence({
    required this.controllersByType,
    required super.child,
  });

  final Map<Type, PersistentController> controllersByType;

  static _InheritedWerkbankPersistence? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedWerkbankPersistence>();
  }

  @override
  bool updateShouldNotify(_InheritedWerkbankPersistence oldWidget) {
    return controllersByType != oldWidget.controllersByType;
  }
}

class _PersistentControllerRegistryImpl
    implements PersistentControllerRegistry {
  final Map<Type, _Registration> _registrationsByType = {};

  @override
  void register<T extends PersistentController<T>>(
    String id,
    T Function() createController,
  ) {
    // TODO: Implement
  }
}

class _Registration {
  _Registration({
    required this.id,
    required this.createController,
  });

  final String id;
  final PersistentController Function() createController;
}
