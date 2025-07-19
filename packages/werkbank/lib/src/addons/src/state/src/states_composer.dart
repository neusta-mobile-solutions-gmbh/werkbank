import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holder.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holders_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_holder.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_management_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension type StatesComposer(UseCaseComposer _c) {
  ValueNotifier<T> immutable<T>(String id, {required T initialValue}) {
    // Ensure that the initial value is actually immutable.
    assert(
      () {
        try {
          // ignore: unnecessary_statements
          (initialValue as dynamic).dispose;
          return false;
        }
        // ignore: avoid_catching_errors
        on NoSuchMethodError catch (_) {
          return true;
        }
      }(),
      '''
Immutable values are required for state management.

The provided initialValue appears to be a mutable object (detected dispose method).
Consider using immutable data types or c.states.mutable().

Common mutable objects to avoid:
• ScrollController, TextEditingController, AnimationController
• Custom objects with mutable properties

For mutable objects, use c.states.mutable() instead.''',
    );

    final stateHolder = ImmutableStateHolder<T>(
      initialValue: initialValue,
    );
    _c.getTransientStateEntry<ImmutableStateHoldersStateEntry>().addStateHolder(
      ImmutableStateHolderId(id),
      stateHolder,
    );
    return stateHolder;
  }

  ValueContainer<T> mutable<T extends Object>(
    String id, {
    required T Function() create,
    required void Function(T value) dispose,
  }) {
    return mutableWithTickerProvider<T>(
      id,
      create: (_) => create(),
      dispose: dispose,
    );
  }

  ValueContainer<T> mutableWithTickerProvider<T extends Object>(
    String id, {
    required T Function(TickerProvider tickerProvider) create,
    required void Function(T value) dispose,
  }) {
    return _c
        .getTransientStateEntry<MutableStateManagementStateEntry>()
        .addMutableStateHolder<T>(
          MutableStateHolderId(id),
          create,
          dispose,
        );
  }
}

extension StatesComposerExtension on UseCaseComposer {
  StatesComposer get states => StatesComposer(this);
}
