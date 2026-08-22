import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/persistence/persistence.dart';
import 'package:werkbank/src/utils/utils.dart';

class GlobalStateManager extends StatefulWidget {
  const GlobalStateManager({
    required this.globalStateConfig,
    required this.registerWerkbankGlobalStateControllers,
    required this.child,
    super.key,
  });

  final GlobalStateConfig globalStateConfig;
  final void Function(
    GlobalStateControllerRegistry registry,
  )
  registerWerkbankGlobalStateControllers;
  final Widget child;

  static GlobalState of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_InheritedGlobalState>();
    if (inherited == null) {
      throw StateError(
        'No GlobalState found in context. Make sure to wrap your widget tree '
        'with a GlobalStateManager.',
      );
    }
    return inherited.globalState;
  }

  @override
  State<GlobalStateManager> createState() => _GlobalStateManagerState();
}

class _GlobalStateManagerState extends State<GlobalStateManager>
    with TickerProviderStateMixin {
  final Map<Type, GlobalStateController> _controllersByType = {};
  final Map<Type, String> _jsonStoreKeysByType = {};
  final Map<Type, ListenableSubscription> _subscriptionsByType = {};
  late final JsonStore _jsonStore;
  bool _updatedControllersThisFrame = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _jsonStore = JsonStoreProvider.read(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllers();
    if (!_isInitialized) {
      _initializeGlobalState();
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(GlobalStateManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllers();
  }

  @override
  void reassemble() {
    super.reassemble();
    _updateControllers();
  }

  GlobalState _createGlobalState() {
    // We need to create a copy of the map because it is mutated later.
    return _GlobalStateImpl(Map.of(_controllersByType));
  }

  void _updateSubscription(Type type) {
    _subscriptionsByType[type]?.cancel();
    final controller = _controllersByType[type]!;
    final jsonStoreKey = _jsonStoreKeysByType[type]!;
    if (controller is! PersistedGlobalStateControllerMixin) {
      return;
    }

    void listener() {
      try {
        final json = controller.toJson();
        _jsonStore.set(jsonStoreKey, json);
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }

    _subscriptionsByType[type] = controller.jsonChangedListenable.listen(
      listener,
    );
    listener();
  }

  void _updateControllers() {
    if (_updatedControllersThisFrame) {
      return;
    }
    final registry = _GlobalStateControllerRegistryImpl(
      tickerProvider: this,
    );
    registry.jsonStoreKeyPrefix = 'werkbank';
    widget.registerWerkbankGlobalStateControllers(registry);
    final addons = AddonConfigProvider.addonsOf(context);
    for (final addon in addons) {
      registry.jsonStoreKeyPrefix = addon.id;
      addon.registerGlobalStateControllers(registry);
    }
    final registrations = registry._registrations;
    final registrationsByType = <Type, _Registration>{};
    final registrationsByJsonStoreKey = <String, _Registration>{};
    for (final registration in registrations) {
      try {
        if (registrationsByType.containsKey(registration.type)) {
          throw AssertionError(
            'Cannot register multiple global state controllers with '
            'the same type: ${registration.type}',
          );
        }
        registrationsByType[registration.type] = registration;
        if (registrationsByJsonStoreKey.containsKey(
          registration.jsonStoreKey,
        )) {
          throw AssertionError(
            'Cannot register multiple global state controllers with '
            'the same jsonStoreKey: ${registration.jsonStoreKey}',
          );
        }
        registrationsByJsonStoreKey[registration.jsonStoreKey] = registration;
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }
    final oldTypes = _jsonStoreKeysByType.keys;
    final newTypes = registrationsByType.keys;

    final removedTypes = oldTypes
        .whereNot(newTypes.contains)
        .toList(growable: false);

    final addedTypes = newTypes
        .whereNot(oldTypes.contains)
        .toList(growable: false);

    final changedJsonStoreKeyTypes = newTypes
        .where((type) {
          if (!oldTypes.contains(type)) {
            return false;
          }
          final oldJsonStoreKey = _jsonStoreKeysByType[type]!;
          final newJsonStoreKey = registrationsByType[type]!.jsonStoreKey;
          return oldJsonStoreKey != newJsonStoreKey;
        })
        .toList(growable: false);

    for (final type in removedTypes) {
      _subscriptionsByType[type]!.cancel();
      _subscriptionsByType.remove(type);
      _controllersByType[type]!.dispose();
      _controllersByType.remove(type);
      _jsonStoreKeysByType.remove(type);
    }

    for (final type in addedTypes) {
      try {
        final registration = registrationsByType[type]!;
        final controller = registration.createController();
        _controllersByType[type] = controller;
        _jsonStoreKeysByType[type] = registration.jsonStoreKey;
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }

    for (final registration in registrations) {
      registration.onUpdate(_controllersByType[registration.type]!);
    }

    final isWarmStart = IsWarmStartProvider.read(context);
    for (final type in addedTypes) {
      final registration = registrationsByType[type]!;
      final controller = _controllersByType[type]!;
      if (controller is PersistedGlobalStateControllerMixin) {
        try {
          final json = _jsonStore.get(registration.jsonStoreKey);
          controller.tryLoadFromJson(json, isWarmStart: isWarmStart);
        } on Object catch (e, stackTrace) {
          Zone.current.handleUncaughtError(e, stackTrace);
        }
      }
    }

    for (final type in addedTypes) {
      _updateSubscription(type);
    }

    for (final type in changedJsonStoreKeyTypes) {
      final newJsonStoreKey = registrationsByType[type]!.jsonStoreKey;
      _jsonStoreKeysByType[type] = newJsonStoreKey;
      _updateSubscription(type);
    }

    _updatedControllersThisFrame = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatedControllersThisFrame = false;
    });
  }

  void _initializeGlobalState() {
    try {
      widget.globalStateConfig.initialize?.call(_createGlobalState());
    } on Object catch (e, stackTrace) {
      Zone.current.handleUncaughtError(e, stackTrace);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllersByType.values) {
      try {
        controller.dispose();
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedGlobalState(
      globalState: _createGlobalState(),
      child: widget.child,
    );
  }
}

class _InheritedGlobalState extends InheritedWidget {
  const _InheritedGlobalState({
    required this.globalState,
    required super.child,
  });

  final GlobalState globalState;

  @override
  bool updateShouldNotify(_InheritedGlobalState oldWidget) {
    return globalState != oldWidget.globalState;
  }
}

class _GlobalStateControllerRegistryImpl
    implements GlobalStateControllerRegistry {
  _GlobalStateControllerRegistryImpl({
    required this.tickerProvider,
  });

  final TickerProvider tickerProvider;

  final List<_Registration> _registrations = [];

  late String jsonStoreKeyPrefix;

  @override
  void register<T extends GlobalStateController>(
    String jsonStoreKey,
    T Function() createController, {
    void Function(T controller)? onUpdate,
  }) {
    _registrations.add(
      _Registration(
        jsonStoreKey: '$jsonStoreKeyPrefix:$jsonStoreKey',
        type: T,
        createController: createController,
        onUpdate: (controller) => onUpdate?.call(controller as T),
      ),
    );
  }

  @override
  void registerWithTickerProvider<T extends GlobalStateController>(
    String jsonStoreKey,
    T Function(TickerProvider tickerProvider) createController, {
    void Function(T controller)? onUpdate,
  }) {
    _registrations.add(
      _Registration(
        jsonStoreKey: '$jsonStoreKeyPrefix:$jsonStoreKey',
        type: T,
        createController: () => createController(tickerProvider),
        onUpdate: (controller) => onUpdate?.call(controller as T),
      ),
    );
  }
}

class _Registration {
  _Registration({
    required this.jsonStoreKey,
    required this.type,
    required this.createController,
    required this.onUpdate,
  });

  final String jsonStoreKey;
  final Type type;
  final GlobalStateController Function() createController;
  final void Function(GlobalStateController controller) onUpdate;
}

class _GlobalStateImpl extends GlobalState {
  _GlobalStateImpl(this._controllersByType);

  final Map<Type, GlobalStateController> _controllersByType;

  @override
  T? maybeGet<T extends GlobalStateController>() {
    return _controllersByType[T] as T?;
  }
}
