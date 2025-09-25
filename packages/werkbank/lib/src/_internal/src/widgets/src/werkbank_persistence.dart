import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/persistence/persistence.dart';
import 'package:werkbank/src/utils/utils.dart';

typedef ControllerMapFactory =
    Map<Type, PersistentController> Function(
      SharedPreferencesWithCache prefsWithCache,
    );

class WerkbankPersistence extends StatefulWidget {
  const WerkbankPersistence({
    required this.persistenceConfig,
    required this.registerWerkbankPersistentControllers,
    required this.placeholder,
    required this.child,
    super.key,
  });

  final PersistenceConfig persistenceConfig;
  final void Function(
    PersistentControllerRegistry registry,
  )
  registerWerkbankPersistentControllers;
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

  static T? maybeControllerOf<T extends PersistentController>(
    BuildContext context,
  ) {
    return _InheritedWerkbankPersistence.of(context)?.controllersByType[T]
        as T?;
  }

  @override
  State<WerkbankPersistence> createState() => _WerkbankPersistenceState();
}

class _WerkbankPersistenceState extends State<WerkbankPersistence> {
  final Map<Type, PersistentController> _controllersByType = {};
  final Map<Type, String> _idsByType = {};
  final Map<Type, ListenableSubscription> _subscriptionsByType = {};
  late final JsonStore _jsonStore;
  bool _updatedControllersThisFrame = false;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // We defer the first frame
    // until the persistence is ready.
    // This way we avoid an empty first frame.
    RendererBinding.instance.deferFirstFrame();
    unawaited(_init());
  }

  Future<void> _init() async {
    // We deliberately do not update the store when the widget is rebuilt.
    _jsonStore = await widget.persistenceConfig.createJsonStore();
    setState(() {
      _initialized = true;
    });
    _updateControllers();
    RendererBinding.instance.allowFirstFrame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllers();
  }

  @override
  void didUpdateWidget(WerkbankPersistence oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllers();
  }

  void _updateSubscription(Type type) {
    _subscriptionsByType[type]?.cancel();
    final controller = _controllersByType[type]!;
    final id = _idsByType[type]!;

    void listener() {
      final json = controller.toJson();
      _jsonStore.set(id, json);
    }

    _subscriptionsByType[type] = controller.listen(listener);
    listener();
  }

  void _updateControllers() {
    if (!_initialized || _updatedControllersThisFrame) {
      return;
    }
    final registry = _PersistentControllerRegistryImpl();
    registry.idPrefix = 'werkbank';
    widget.registerWerkbankPersistentControllers(registry);
    final addons = AddonConfigProvider.addonsOf(context);
    for (final addon in addons) {
      registry.idPrefix = addon.id;
      addon.registerPersistentControllers(registry);
    }
    final registrations = registry._registrations;
    final registrationsByType = <Type, _Registration>{};
    final registrationsById = <String, _Registration>{};
    for (final registration in registrations) {
      try {
        if (registrationsByType.containsKey(registration.type)) {
          throw AssertionError(
            'Cannot register multiple persistent controllers with '
            'the same type: ${registration.type}',
          );
        }
        registrationsByType[registration.type] = registration;
        if (registrationsById.containsKey(registration.id)) {
          throw AssertionError(
            'Cannot register multiple persistent controllers with '
            'the same id: ${registration.id}',
          );
        }
        registrationsById[registration.id] = registration;
      } on Object catch (e, stackTrace) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    final oldTypes = _idsByType.keys;
    final newTypes = registrationsByType.keys;

    final removedTypes = oldTypes
        .whereNot(newTypes.contains)
        .toList(growable: false);

    final addedTypes = newTypes
        .whereNot(oldTypes.contains)
        .toList(growable: false);

    final changedIdTypes = newTypes
        .where((type) {
          if (!oldTypes.contains(type)) {
            return false;
          }
          final oldId = _idsByType[type]!;
          final newId = registrationsByType[type]!.id;
          return oldId != newId;
        })
        .toList(growable: false);

    for (final type in removedTypes) {
      _subscriptionsByType[type]!.cancel();
      _subscriptionsByType.remove(type);
      _controllersByType[type]!.dispose();
      _controllersByType.remove(type);
      _idsByType.remove(type);
    }

    for (final type in addedTypes) {
      try {
        final registration = registrationsByType[type]!;
        final controller = registration.createController();
        try {
          for (final initialization
              in widget.persistenceConfig.initializations) {
            initialization.tryInitialize(controller);
          }
          final json = _jsonStore.get(registration.id);
          controller.tryLoadFromJson(json);
        } on Object catch (e, stackTrace) {
          controller.dispose();
          debugPrint(e.toString());
          debugPrintStack(stackTrace: stackTrace);
        }
        _controllersByType[type] = controller;
        _idsByType[type] = registration.id;
        _updateSubscription(type);
      } on Object catch (e, stackTrace) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    for (final type in changedIdTypes) {
      final newId = registrationsByType[type]!.id;
      _idsByType[type] = newId;
      _updateSubscription(type);
    }

    _updatedControllersThisFrame = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatedControllersThisFrame = false;
    });
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
      // We need to create a copy of the map
      controllersByType: Map.of(_controllersByType),
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
  final List<_Registration> _registrations = [];

  late String idPrefix;

  @override
  void register<T extends PersistentController>(
    String id,
    T Function() createController,
  ) {
    _registrations.add(
      _Registration(
        id: '$idPrefix:$id',
        type: T,
        createController: createController,
      ),
    );
  }
}

class _Registration {
  _Registration({
    required this.id,
    required this.type,
    required this.createController,
  });

  final String id;
  final Type type;
  final PersistentController Function() createController;
}
