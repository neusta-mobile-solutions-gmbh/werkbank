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

  @override
  Widget build(
    BuildContext context,
    GlobalStateControllerBuildData data,
    Widget child,
  ) => _Persister(
    controller: this,
    jsonStore: data.jsonStore,
    isWarmStart: data.isWarmStart,
    child: super.build(context, data, child),
  );
}

class _Persister extends StatefulWidget {
  const _Persister({
    required this.controller,
    required this.jsonStore,
    required this.isWarmStart,
    required this.child,
  });

  final PersistedGlobalStateControllerMixin controller;
  final JsonStore jsonStore;
  final bool isWarmStart;

  final Widget child;

  @override
  State<_Persister> createState() => _PersisterState();
}

class _PersisterState extends State<_Persister> {
  late final ListenableSubscription _jsonChangedSubscription;

  @override
  void initState() {
    super.initState();
    try {
      widget.controller.tryLoadFromJson(
        widget.jsonStore.get(widget.controller.jsonStoreKey),
        isWarmStart: widget.isWarmStart,
      );
    } on Object catch (e, stackTrace) {
      Zone.current.handleUncaughtError(e, stackTrace);
    }
    _jsonChangedSubscription = widget.controller.jsonChangedListenable.listen(
      () {
        try {
          final json = widget.controller.toJson();
          widget.jsonStore.set(widget.controller.jsonStoreKey, json);
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

  @override
  Widget build(BuildContext context) => widget.child;
}
