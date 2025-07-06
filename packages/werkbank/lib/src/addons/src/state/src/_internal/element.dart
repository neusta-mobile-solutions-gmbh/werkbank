import 'package:flutter/foundation.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/buildable_element.dart';

extension type ElementId(String _label) {}

abstract interface class Element<T> {
  String get label;
  T get value;
}

extension ElementExtension<T> on Element<T> {
  ElementId get id => ElementId(label);
}

// abstract interface class WritableElement<T> extends Element<T>

//   @override
//   set value(T value);
// }
