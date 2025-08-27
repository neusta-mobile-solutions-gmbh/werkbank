import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/immutable/immutable_state_holder.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/immutable/immutable_state_holders_state_entry.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/mutable/mutable_state_management_state_entry.dart';
import 'package:werkbank/src/addons/src/state_keeping/state_keeping.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// {@category Keeping State}
extension type StatesComposer(UseCaseComposer _c) {
  /// Creates a [ValueNotifier] of an immutable object.
  ///
  /// {@template werkbank.states.id}
  /// The [id] uniquely identifies the state, ensuring it persists across
  /// hot reloads.
  /// {@endtemplate}
  ///
  /// The [initialValue] defines the value of the [ValueNotifier]
  /// when first created.
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
      ImmutableStateId(id),
      stateHolder,
    );
    return stateHolder;
  }

  /// Creates a [ValueContainer] of a mutable object.
  ///
  /// {@macro werkbank.states.id}
  ///
  /// {@template werkbank.states.mutable.lifecycle}
  /// The [create] function will be executed before you use the
  /// value of [ValueContainer] in your UseCase's [WidgetBuilder].
  ///
  /// The mutable object will persist through hot reloads.
  ///
  /// [dispose] will be called when the UseCase is disposed.
  /// {@endtemplate}
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

  /// Creates a [ValueContainer] of a mutable object
  /// and provides a [TickerProvider] for it.
  ///
  /// {@macro werkbank.states.id}
  ///
  /// {@macro werkbank.states.mutable.lifecycle}
  ValueContainer<T> mutableWithTickerProvider<T extends Object>(
    String id, {
    required T Function(TickerProvider tickerProvider) create,
    required void Function(T value) dispose,
  }) {
    return _c
        .getTransientStateEntry<MutableStateManagementStateEntry>()
        .addMutableStateHolder<T>(
          MutableStateId(id),
          create,
          dispose,
        );
  }
}

extension StatesComposerExtension on UseCaseComposer {
  StatesComposer get states => StatesComposer(this);
}
