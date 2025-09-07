import 'dart:async';

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
  Map<Type, PersistentController> _controllersByType = {};
  Map<Type, String> _idsByType = {};
  Map<Type, ListenableSubscription> _subscriptionsByType = {};
  late final JsonStore _jsonStore;

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
    _updateControllers();
    setState(() {
      _initialized = true;
      RendererBinding.instance.allowFirstFrame();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _updateSubscription(Type type) {
    _subscriptionsByType[type]!.cancel();
    final controller = _controllersByType[type]!;
    _subscriptionsByType[type] = controller.listen(() {
      final id = _idsByType[type]!;
      final json = controller.toJson();
      _jsonStore.set(id, json);
    });
  }

  void _updateControllers() {
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
    final oldTypes = _idsByType.keys.toSet();
    final newTypes = registrationsByType.keys.toSet();
    final addedTypes = newTypes.difference(oldTypes);
    final removedTypes = oldTypes.difference(newTypes);
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
