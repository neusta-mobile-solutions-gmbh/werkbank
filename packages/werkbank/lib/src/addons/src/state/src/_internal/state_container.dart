import 'package:flutter/material.dart';

extension type StateContainerId(String _label) {}

abstract interface class StateContainer<T> {
  String get label;
  ValueNotifier<T> get notifier;
}

extension StateContainerExtension<T> on StateContainer<T> {
  StateContainerId get id => StateContainerId(label);
}
