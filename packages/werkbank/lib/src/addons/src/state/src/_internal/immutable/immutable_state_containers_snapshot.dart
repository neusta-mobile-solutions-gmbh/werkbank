import 'package:flutter/material.dart';

@immutable
class ImmutableStateContainerSnapshot {
  const ImmutableStateContainerSnapshot({
    required this.value,
  });

  final Object? value;
}
