import 'package:flutter/material.dart';

extension type ElementId(String _label) {}

abstract interface class Element<T> {
  String get label;
  ValueNotifier<T> get notifier;
}

extension ElementExtension<T> on Element<T> {
  ElementId get id => ElementId(label);
}
