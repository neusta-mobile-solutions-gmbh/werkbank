import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/buildable_state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_containers_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension type StatesComposer(UseCaseComposer _c) {
  ValueNotifier<T> register<T>(String label, {required T initialValue}) {
    final stateContainer = BuildableStateContainer<T>(
      label: label,
      initialValue: initialValue,
    );
    _c.getTransientStateEntry<StateContainersStateEntry>().addStateContainer(
      stateContainer,
    );
    return stateContainer.notifier;
  }

  // TODO(lwiedekamp): registerMutable
}

extension StatesComposerExtension on UseCaseComposer {
  StatesComposer get states => StatesComposer(this);
}
