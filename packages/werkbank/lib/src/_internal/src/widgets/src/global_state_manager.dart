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
  final Map<Type, _GlobalStateControllerWithAddon> _controllersByType = {};
  final Map<Type, ListenableSubscription> _subscriptionsByType = {};
  late final JsonStore _jsonStore;
  bool _updatedControllersThisFrame = false;
  bool _isInitialized = false;
  final GlobalKey _childKey = GlobalKey();

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
    return _GlobalStateImpl({
      for (final entry in _controllersByType.entries)
        entry.key: entry.value.controller,
    });
  }

  GlobalStateControllerData _createGlobalStateControllerData(
    _GlobalStateControllerWithAddon controllerWithAddon,
  ) {
    return GlobalStateControllerData(
      jsonStore: _PrefixingJsonStore(
        prefix: controllerWithAddon.addonId,
        delegate: _jsonStore,
      ),
      globalState: _createGlobalState(),
      isWarmStart: IsWarmStartProvider.read(context),
    );
  }

  void _updateControllers() {
    if (_updatedControllersThisFrame) {
      return;
    }
    final registry = _GlobalStateControllerRegistryImpl(
      tickerProvider: this,
    );
    registry.addonId = 'werkbank';
    widget.registerWerkbankGlobalStateControllers(registry);
    final addons = AddonConfigProvider.addonsOf(context);
    for (final addon in addons) {
      registry.addonId = addon.id;
      addon.registerGlobalStateControllers(registry);
    }
    final registrations = registry._registrations;
    final registrationsByType = <Type, _Registration>{};
    for (final registration in registrations) {
      try {
        if (registrationsByType.containsKey(registration.type)) {
          throw AssertionError(
            'Cannot register multiple global state controllers with '
            'the same type: ${registration.type}',
          );
        }
        registrationsByType[registration.type] = registration;
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }
    final oldTypes = _controllersByType.keys;
    final newTypes = registrationsByType.keys;

    final removedTypes = oldTypes
        .whereNot(newTypes.contains)
        .toList(growable: false);

    final addedTypes = newTypes
        .whereNot(oldTypes.contains)
        .toList(growable: false);

    for (final type in removedTypes) {
      _subscriptionsByType[type]!.cancel();
      _subscriptionsByType.remove(type);
      // We don't want others to use the protected `dispose` method,
      // but we need to call it here.
      // ignore: invalid_use_of_protected_member
      _controllersByType[type]!.controller.dispose();
      _controllersByType.remove(type);
    }

    for (final type in addedTypes) {
      try {
        final registration = registrationsByType[type]!;
        final controller = registration.createController();
        _controllersByType[type] = _GlobalStateControllerWithAddon(
          controller: controller,
          addonId: registration.addonId,
        );
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }

    for (final type in addedTypes) {
      final registration = registrationsByType[type]!;
      final controllerWithAddon = _controllersByType[type]!;
      final controller = controllerWithAddon.controller;
      final data = _createGlobalStateControllerData(controllerWithAddon);
      try {
        registration.init(controller, data);
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }

    for (final registration in registrations) {
      registration.onUpdate(_controllersByType[registration.type]!.controller);
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
    for (final controllerWithAddon in _controllersByType.values) {
      try {
        // We don't want others to use the protected `dispose` method,
        // but we need to call it here.
        // ignore: invalid_use_of_protected_member
        controllerWithAddon.controller.dispose();
      } on Object catch (e, stackTrace) {
        Zone.current.handleUncaughtError(e, stackTrace);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: remove?
    Widget result = KeyedSubtree(
      // Technically we should not need a GlobalKey here, since the
      // global state controllers are required to preserve the state of
      // the child.
      // But this is a safe guard in case a global state controller
      // does not do that.
      key: _childKey,
      child: widget.child,
    );
    final globalState = _createGlobalState();
    for (final controllerWithAddon in _controllersByType.values) {
      // We need to store this, because result will have changed by the type
      // the builder is called.
      final child = result;
      result = Builder(
        // TODO: Use copy of nested package? Also for addons?
        // We need to use a GlobalKey here, because the widgets built by
        // the global state controllers must not lose their state when
        // new global state controllers are added or removed.
        key: _GlobalStateControllerGlobalKey(controllerWithAddon.controller),
        builder: (context) {
          final data = _createGlobalStateControllerData(
            controllerWithAddon,
          );
          // We don't want others to use the protected `build` method,
          // but we need to call it here.
          // ignore: invalid_use_of_protected_member
          return controllerWithAddon.controller.build(context, data, child);
        },
      );
    }
    return _InheritedGlobalState(
      globalState: globalState,
      child: result,
    );
  }
}

class _GlobalStateControllerGlobalKey extends GlobalObjectKey {
  const _GlobalStateControllerGlobalKey(super.value);
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

class _GlobalStateControllerWithAddon {
  _GlobalStateControllerWithAddon({
    required this.controller,
    required this.addonId,
  });

  final GlobalStateController controller;
  final String addonId;
}

class _GlobalStateControllerRegistryImpl
    implements GlobalStateControllerRegistry {
  _GlobalStateControllerRegistryImpl({
    required this.tickerProvider,
  });

  final TickerProvider tickerProvider;

  final List<_Registration> _registrations = [];

  late String addonId;

  @override
  void register<T extends GlobalStateController>(
    T Function() createController, {
    void Function(T controller)? onUpdate,
  }) {
    _registrations.add(
      _Registration(
        type: T,
        createController: createController,
        onUpdate: (controller) => onUpdate?.call(controller as T),
        // We don't want others to use the protected `init` method,
        // but we need to call it here.
        // ignore: invalid_use_of_protected_member
        init: (controller, data) => controller.init<T>(data),
        addonId: addonId,
      ),
    );
  }

  @override
  void registerWithTickerProvider<T extends GlobalStateController>(
    T Function(TickerProvider tickerProvider) createController, {
    void Function(T controller)? onUpdate,
  }) {
    _registrations.add(
      _Registration(
        type: T,
        createController: () => createController(tickerProvider),
        onUpdate: (controller) => onUpdate?.call(controller as T),
        // We don't want others to use the protected `init` method,
        // but we need to call it here.
        // ignore: invalid_use_of_protected_member
        init: (controller, data) => controller.init<T>(data),
        addonId: addonId,
      ),
    );
  }
}

class _Registration {
  _Registration({
    required this.type,
    required this.createController,
    required this.onUpdate,
    required this.init,
    required this.addonId,
  });

  final Type type;
  final GlobalStateController Function() createController;
  final void Function(GlobalStateController controller) onUpdate;
  final void Function(
    GlobalStateController controller,
    GlobalStateControllerData data,
  )
  init;
  final String addonId;
}

class _GlobalStateImpl extends GlobalState {
  _GlobalStateImpl(this._controllersByType);

  final Map<Type, GlobalStateController> _controllersByType;

  @override
  T? maybeGet<T extends GlobalStateController>() {
    return _controllersByType[T] as T?;
  }
}

class _PrefixingJsonStore implements JsonStore {
  _PrefixingJsonStore({
    required this.prefix,
    required this.delegate,
  });

  final String prefix;
  final JsonStore delegate;

  @override
  Object? get(String key) {
    return delegate.get('$prefix:$key');
  }

  @override
  void set(String key, Object? value) {
    delegate.set('$prefix:$key', value);
  }
}
