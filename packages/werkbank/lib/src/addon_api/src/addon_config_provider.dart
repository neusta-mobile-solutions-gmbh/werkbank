import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class AddonConfigProvider extends InheritedWidget {
  const AddonConfigProvider({
    super.key,
    required this.addonConfig,
    required super.child,
  });

  static AddonConfig of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<AddonConfigProvider>();
    assert(result != null, 'No AddonsProvider found in context');
    return result!.addonConfig;
  }

  static List<Addon> addonsOf(BuildContext context) {
    return of(context).addons;
  }

  final AddonConfig addonConfig;

  @override
  bool updateShouldNotify(AddonConfigProvider oldWidget) {
    return oldWidget.addonConfig != addonConfig;
  }
}
