/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
library;

import 'package:flutter/material.dart';

/// A controller that manages and persists state that is global to
/// the whole application.
///
/// [Addon]s can create and register [GlobalStateController]s by overriding the
/// [Addon.registerGlobalStateControllers] method.
abstract class GlobalStateController {
  void dispose();
}

abstract class ValueNotifierGlobalStateController<T> extends ValueNotifier<T>
    implements GlobalStateController {
  ValueNotifierGlobalStateController(super._value);
}

/// When using this mixin, you must implement the [tryLoadFromJson]
/// and [toJson] methods to load and persist the state.
/// Once the [GlobalStateController] changes its state in a way that
/// would change the value returned by [toJson], the [jsonChangedListenable]
/// must notify its listeners.
mixin PersistedGlobalStateControllerMixin on GlobalStateController {
  /// A listenable that notifies its listeners if the value returned by
  /// [toJson] has changed.
  Listenable get jsonChangedListenable;

  void tryLoadFromJson(Object? json, {required bool isWarmStart});

  Object? toJson();
}

mixin NotifiablePersistedGlobalStateControllerMixin on GlobalStateController
    implements PersistedGlobalStateControllerMixin {
  final _jsonChangedNotifier = _JsonChangedNotifier();

  @override
  Listenable get jsonChangedListenable => _jsonChangedNotifier;

  void notifyJsonChanged() {
    _jsonChangedNotifier.notifyPersistenceChanged();
  }
}

class _JsonChangedNotifier extends ChangeNotifier {
  void notifyPersistenceChanged() {
    notifyListeners();
  }
}

mixin ListeningPersistedGlobalStateControllerMixin
    on GlobalStateController, Listenable
    implements PersistedGlobalStateControllerMixin {
  @override
  Listenable get jsonChangedListenable => this;
}
