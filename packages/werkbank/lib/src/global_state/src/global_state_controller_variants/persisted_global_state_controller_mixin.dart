/// @docImport 'package:werkbank/src/persistence/persistence.dart';
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/persistence/persistence.dart';
import 'package:werkbank/src/utils/utils.dart';

/// When using this mixin, you must implement the [tryLoadFromJson]
/// and [toJson] methods to load and persist the state.
/// Once the [GlobalStateController] changes its state in a way that
/// would change the value returned by [toJson], the [jsonChangedListenable]
/// must notify its listeners.
mixin PersistedGlobalStateControllerMixin on GlobalStateController {
  /// Used as a key to store the json produced by
  /// the [toJson] method in the [JsonStore] defined by
  /// the used [PersistenceConfig].
  String get jsonStoreKey;

  /// A listenable that notifies its listeners if the value returned by
  /// [toJson] has changed.
  ///
  /// The getter must always return the same [Listenable] instance over
  /// the lifetime of the [GlobalStateController].
  Listenable get jsonChangedListenable;

  void tryLoadFromJson(Object? json, {required bool isWarmStart});

  Object? toJson();

  late final ListenableSubscription _jsonChangedSubscription;

  @override
  void init<C extends GlobalStateController>(GlobalStateControllerData data) {
    super.init<C>(data);
    try {
      tryLoadFromJson(
        data.jsonStore.get(jsonStoreKey),
        isWarmStart: data.isWarmStart,
      );
    } on Object catch (e, stackTrace) {
      Zone.current.handleUncaughtError(e, stackTrace);
    }
    _jsonChangedSubscription = jsonChangedListenable.listen(
      () {
        try {
          final json = toJson();
          data.jsonStore.set(jsonStoreKey, json);
        } on Object catch (e, stackTrace) {
          Zone.current.handleUncaughtError(e, stackTrace);
        }
      },
    );
  }

  @override
  void dispose() {
    _jsonChangedSubscription.cancel();
    super.dispose();
  }
}
