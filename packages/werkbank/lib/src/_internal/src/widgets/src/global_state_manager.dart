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

  /// {@template werkbank.controller_available_in_app}
  /// If the current context is a Werkbank App, not
  /// a UseCaseDisplay, it is safe to assume that the
  /// controller is available.
  /// {@endtemplate}
  static HistoryController? maybeHistoryOf(BuildContext context) {
    return maybeControllerOf<HistoryController>(context);
  }

  /// {@macro werkbank.controller_available_in_app}
  static PanelTabsController? maybePanelTabsControllerOf(BuildContext context) {
    return maybeControllerOf<PanelTabsController>(context);
  }

  /// {@macro werkbank.controller_available_in_app}
  static SearchQueryController? maybeSearchQueryControllerOf(
    BuildContext context,
  ) {
    return maybeControllerOf<SearchQueryController>(context);
  }

  static T? maybeControllerOf<T extends GlobalStateController>(
    BuildContext context,
  ) {
    return _InheritedWerkbankPersistence.of(context)?.controllersByType[T]
        as T?;
  }

  @override
  State<GlobalStateManager> createState() => _GlobalStateManagerState();
}

class _GlobalStateManagerState extends State<GlobalStateManager> {
  final Map<Type, GlobalStateController> _controllersByType = {};
  final Map<Type, String> _idsByType = {};
  final Map<Type, ListenableSubscription> _subscriptionsByType = {};
  late final JsonStore _jsonStore;
  bool _updatedControllersThisFrame = false;

  @override
  void initState() {
    super.initState();
    _jsonStore = JsonStoreProvider.read(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllers();
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

  void _updateSubscription(Type type) {
    _subscriptionsByType[type]?.cancel();
    final controller = _controllersByType[type]!;
    final id = _idsByType[type]!;

    void listener() {
      final json = controller.toJson();
      _jsonStore.set(id, json);
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
    final registry = _GlobalStateControllerRegistryImpl();
    registry.idPrefix = 'werkbank';
    widget.registerWerkbankGlobalStateControllers(registry);
    final addons = AddonConfigProvider.addonsOf(context);
    for (final addon in addons) {
      registry.idPrefix = addon.id;
      addon.registerGlobalStateControllers(registry);
    }
    final registrations = registry._registrations;
    final registrationsByType = <Type, _Registration>{};
    final registrationsById = <String, _Registration>{};
    for (final registration in registrations) {
      try {
        if (registrationsByType.containsKey(registration.type)) {
          throw AssertionError(
            'Cannot register multiple global state controllers with '
            'the same type: ${registration.type}',
          );
        }
        registrationsByType[registration.type] = registration;
        if (registrationsById.containsKey(registration.id)) {
          throw AssertionError(
            'Cannot register multiple global state controllers with '
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

    final isWarmStart = IsWarmStartProvider.read(context);
    for (final type in addedTypes) {
      try {
        final registration = registrationsByType[type]!;
        final controller = registration.createController();
        try {
          for (final initialization
              in widget.globalStateConfig.initializations) {
            initialization.tryInitialize(controller);
          }
          final json = _jsonStore.get(registration.id);
          controller.tryLoadFromJson(json, isWarmStart: isWarmStart);
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

  final Map<Type, GlobalStateController> controllersByType;

  static _InheritedWerkbankPersistence? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedWerkbankPersistence>();
  }

  @override
  bool updateShouldNotify(_InheritedWerkbankPersistence oldWidget) {
    return controllersByType != oldWidget.controllersByType;
  }
}

class _GlobalStateControllerRegistryImpl
    implements GlobalStateControllerRegistry {
  final List<_Registration> _registrations = [];

  late String idPrefix;

  @override
  void register<T extends GlobalStateController>(
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
  final GlobalStateController Function() createController;
}
