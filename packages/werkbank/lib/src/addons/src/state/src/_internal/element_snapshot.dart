import 'package:flutter/material.dart';

@immutable
class ElementSnapshot {
  const ElementSnapshot({
    required this.value,
  });

  final Object? value;
}
