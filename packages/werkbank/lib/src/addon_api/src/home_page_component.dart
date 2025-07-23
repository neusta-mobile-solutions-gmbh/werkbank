import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/src/accessor/addon_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/werkbank_app_only_accessor.dart';
import 'package:werkbank/src/utils/utils.dart';

class HomePageComponent {
  const HomePageComponent({
    this.title,
    required this.sortHint,
    required this.child,
  });

  static const access = HomePageComponentAccessor();

  final Widget? title;
  final SortHint sortHint;
  final Widget child;
}

class HomePageComponentAccessor extends AddonAccessor
    with WerkbankAppOnlyAccessor {
  const HomePageComponentAccessor();

  @override
  String get containerName => 'HomePageComponent';
}
