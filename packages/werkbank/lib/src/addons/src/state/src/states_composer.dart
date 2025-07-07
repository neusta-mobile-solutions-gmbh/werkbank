import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/buildable_element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/elements_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension type StatesComposer(UseCaseComposer _c) {
  ValueNotifier<T> register<T>(String label, T element) {
    final buildableElement = BuildableElement<T>(
      label: label,
      initialValue: element,
    );
    _c.getTransientStateEntry<ElementsStateEntry>().addElement(
      buildableElement,
    );
    return buildableElement.notifier;
  }

  // registerMutable
}

extension StatesComposerExtension on UseCaseComposer {
  StatesComposer get states => StatesComposer(this);
}
