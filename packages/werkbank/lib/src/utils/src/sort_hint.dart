import 'package:flutter/material.dart';

@immutable
class SortHint implements Comparable<SortHint> {
  const SortHint(this.index);

  static const SortHint beforeMost = SortHint(-1000);
  static const SortHint central = SortHint(0);
  static const SortHint afterMost = SortHint(1000);

  final int index;

  @override
  int compareTo(SortHint other) => index.compareTo(other.index);
}
