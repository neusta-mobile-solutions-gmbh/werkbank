import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_retainment_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable_state_ticker_provider_provider.dart';
import 'package:werkbank/werkbank.dart';

class MutableStateManagementStateEntry
    extends
        TransientUseCaseStateEntry<
          MutableStateManagementStateEntry,
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
    // ignore: cascade_invocations
    retainmentStateEntry.clean(
      (id) => !_stateBundlesById.containsKey(id),
    );
    for (final MapEntry(key: id, value: bundle) in _stateBundlesById.entries) {
      final currentValue = retainmentStateEntry.getMutableValue(id);
      final hasValue =
          currentValue != null && bundle.trySetContainerValue(currentValue);
      if (!hasValue) {
        final tickerProvider = MutableStateTickerProviderProvider.of(context);
        final value = bundle.createAndSetContainerValue(tickerProvider);
        retainmentStateEntry.setMutableValue(
          id,
          value,
          bundle.tryDispose,
        );
      }
    }
  }

  MutableValueContainer<T> addMutableStateContainer<T extends Object>(
    MutableStateContainerId id,
    T Function(TickerProvider tickerProvider) create,
    void Function(T value) dispose,
  ) {
    assert(
      !_stateBundlesById.containsKey(id),
      'Mutable value with id "$id" already exists',
    );
    final container = MutableStateContainer<T>();
    final bundle = _MutableStateBundle<T>(
      container: container,
      create: create,
      dispose: dispose,
    );
    _stateBundlesById[id] = bundle;
    return container;
  }

  @override
  void loadSnapshot(TransientUseCaseStateSnapshot snapshot) {}

  @override
  TransientUseCaseStateSnapshot saveSnapshot() =>
      const TransientUseCaseStateSnapshot();
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

  bool trySetContainerValue(Object value) {
    if (value is! T) {
      return false;
    }
    container.prepareForBuild(value);
    return true;
  }

  T createAndSetContainerValue(
    TickerProvider tickerProvider,
  ) {
    final value = create(tickerProvider);
    container.prepareForBuild(value);
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
