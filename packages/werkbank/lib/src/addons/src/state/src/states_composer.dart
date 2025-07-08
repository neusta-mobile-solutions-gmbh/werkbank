import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/buildable_element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/elements_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension type StatesComposer(UseCaseComposer _c) {
  ValueNotifier<T> register<T>(String label, {required T initialValue}) {
    final element = BuildableElement<T>(
      label: label,
      initialValue: initialValue,
    );
    _c.getTransientStateEntry<ElementsStateEntry>().addElement(
      element,
    );
    return element.notifier;
  }

  // TODO(lwiedekamp): registerMutable
}

extension StatesComposerExtension on UseCaseComposer {
  StatesComposer get states => StatesComposer(this);
}
