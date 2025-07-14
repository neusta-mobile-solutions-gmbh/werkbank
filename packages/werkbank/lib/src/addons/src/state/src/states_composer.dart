import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_containers_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension type StatesComposer(UseCaseComposer _c) {
  ValueNotifier<T> immutable<T>(String label, {required T initialValue}) {
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

    final stateContainer = StateContainer<T>(
      initialValue: initialValue,
    );
    _c.getTransientStateEntry<StateContainersStateEntry>().addStateContainer(
      StateContainerId(label),
      stateContainer,
    );
    return stateContainer.notifier;
  }
}

extension StatesComposerExtension on UseCaseComposer {
  StatesComposer get states => StatesComposer(this);
}
