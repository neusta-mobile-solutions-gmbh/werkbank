import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_holder.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_retainment_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable_state_ticker_provider_provider.dart';
import 'package:werkbank/werkbank.dart';

class MutableStateManagementStateEntry
    extends
        TransientUseCaseStateEntry<
          MutableStateManagementStateEntry,
          TransientUseCaseStateSnapshot
        > {
  final Map<MutableStateId, _MutableStateBundle> _stateBundlesById = {};

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    final retainmentStateEntry = composition
        .getRetainedStateEntry<MutableStateRetainmentStateEntry>();
    // ignore: cascade_invocations
    retainmentStateEntry.clean(
      (id) => !_stateBundlesById.containsKey(id),
    );
    for (final MapEntry(key: id, value: bundle) in _stateBundlesById.entries) {
      final currentValue = retainmentStateEntry.getMutableValue(id);
      final hasValue =
          currentValue != null && bundle.trySetHolderValue(currentValue);
      if (!hasValue) {
        final tickerProvider = MutableStateTickerProviderProvider.of(context);
        final value = bundle.createAndSetHolderValue(tickerProvider);
        retainmentStateEntry.setMutableValue(
          id,
          value,
          bundle.tryDispose,
        );
      }
    }
  }

  ValueContainer<T> addMutableStateHolder<T extends Object>(
    MutableStateId id,
    T Function(TickerProvider tickerProvider) create,
    void Function(T value) dispose,
  ) {
    assert(
      !_stateBundlesById.containsKey(id),
      'Mutable value with id "$id" already exists',
    );
    final holder = MutableStateHolder<T>();
    final bundle = _MutableStateBundle<T>(
      holder: holder,
      create: create,
      dispose: dispose,
    );
    _stateBundlesById[id] = bundle;
    return holder;
  }

  Map<MutableStateId, MutableStateHolder<Object?>> get stateHolders =>
      UnmodifiableMapView(
        _stateBundlesById.map((key, value) => MapEntry(key, value.holder)),
      );

  @override
  void loadSnapshot(TransientUseCaseStateSnapshot snapshot) {}

  @override
  TransientUseCaseStateSnapshot saveSnapshot() =>
      const TransientUseCaseStateSnapshot();
}

class _MutableStateBundle<T extends Object> {
  _MutableStateBundle({
    required this.holder,
    required this.create,
    required this.dispose,
  });

  final MutableStateHolder<T> holder;
  final T Function(TickerProvider tickerProvider) create;
  final void Function(T value) dispose;

  bool trySetHolderValue(Object value) {
    if (value is! T) {
      return false;
    }
    holder.prepareForBuild(value);
    return true;
  }

  T createAndSetHolderValue(
    TickerProvider tickerProvider,
  ) {
    final value = create(tickerProvider);
    holder.prepareForBuild(value);
    return value;
  }

  void tryDispose(Object? value) {
    if (value is T) {
      dispose(value);
    } else {
      throw ArgumentError(
        'Value must be of type $T, but was ${value.runtimeType}',
      );
    }
  }
}
