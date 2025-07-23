import 'package:flutter/material.dart';
import 'package:werkbank/src/utils/utils.dart';

abstract class AddonControlSection {
  const AddonControlSection({
    required this.id,
    required this.title,
    required this.children,
    this.sortHint = SortHint.central,
  });

  final String id;
  final Widget title;
  final List<Widget> children;
  final SortHint sortHint;
}
