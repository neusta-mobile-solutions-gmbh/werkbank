import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_retainment_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/mutable_value_container.dart';
import 'package:werkbank/werkbank.dart';

class MutableStateManagmentStateEntry
    extends
        TransientUseCaseStateEntry<
          MutableStateManagmentStateEntry,
          TransientUseCaseStateSnapshot
        > {
  final Map<MutableStateContainerId, _MutableStateBundle> _stateBundlesById =
      {};

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    final retainmentStateEntry = composition
        .getRetainedStateEntry<MutableStateRetainmentStateEntry>();
    for (final MapEntry(key: id, value: bundle) in _stateBundlesById.entries) {
      final currentValue = retainmentStateEntry.getMutableValue(id);
      // bundle.container.prepareForBuild(currentValue);
    }
  }

  @override
  Listenable? createRebuildListenable() {
    // TODO: Should mutable state be allowed to define a rebuild listenable?
  }

  MutableValueContainer<T> addMutableStateContainer<T extends Object>(
    MutableStateContainerId label,
    T Function(TickerProvider tickerProvider) create,
    void Function(T value) dispose,
  ) {
    assert(
      !_stateBundlesById.containsKey(label),
      'Mutable value with label "$label" already exists',
    );
    final container = MutableStateContainer<T>();
    final bundle = _MutableStateBundle<T>(
      container: container,
      create: create,
      dispose: dispose,
    );
    _stateBundlesById[label] = bundle;
    return container;
  }

  @override
  void loadSnapshot(TransientUseCaseStateSnapshot snapshot) {}

  @override
  TransientUseCaseStateSnapshot saveSnapshot() =>
      const TransientUseCaseStateSnapshot();

  @override
  void dispose() {
    super.dispose();
  }
}

class _MutableStateBundle<T extends Object> {
  _MutableStateBundle({
    required this.container,
    required this.create,
    required this.dispose,
  });

  final MutableStateContainer<T> container;
  final T Function(TickerProvider tickerProvider) create;
  final void Function(T value) dispose;
}
