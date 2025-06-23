import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ValueNotifierExtension<T> on ValueNotifier<T> {
  /// A method to change the value of the [ValueNotifier].
  /// This functions just like the setter for [value], but can be passed as a
  /// callback to parameters like `onValueChanged`.
  // ignore: use_setters_to_change_properties
  void setValue(T value) => this.value = value;
}
