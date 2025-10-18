/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
library;

import 'package:flutter/material.dart';

/// A controller that manages and persists state that is global to
/// the whole application.
///
/// When extending this class, you must implement the [tryLoadFromJson]
/// and [toJson] methods to load and persist the state.
/// Once the [GlobalStateController] changes its state in a way that
/// would change the value returned by [toJson], it must call
/// [notifyListeners] with `hasJsonChanged` set to `true` (the default).
///
///
/// [Addon]s can create and register [GlobalStateController]s by overriding the
/// [Addon.registerGlobalStateControllers] method.
abstract class GlobalStateController extends ChangeNotifier {
  final _jsonChangedNotifier = _JsonChangedNotifier();

  /// A listenable that notifies its listeners if the value returned by
  /// [toJson] has changed.
  Listenable get jsonChangedListenable => _jsonChangedNotifier;

  void tryLoadFromJson(Object? json, {required bool isWarmStart});

  Object? toJson();

  @override
  void notifyListeners({bool hasJsonChanged = true}) {
    super.notifyListeners();
    if (hasJsonChanged) {
      _jsonChangedNotifier.notifyPersistenceChanged();
    }
  }
}

class _JsonChangedNotifier extends ChangeNotifier {
  void notifyPersistenceChanged() {
    notifyListeners();
  }
}
