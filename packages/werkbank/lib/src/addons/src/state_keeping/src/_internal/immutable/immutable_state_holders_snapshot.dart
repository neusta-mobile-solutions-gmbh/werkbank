import 'package:flutter/material.dart';

@immutable
class ImmutableStateHolderSnapshot {
  const ImmutableStateHolderSnapshot({
    required this.value,
  });

  final Object? value;
}
