import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addon_config/addon_config.dart';

class AddonConfigProvider extends StatelessWidget {
  const AddonConfigProvider({
    super.key,
    required this.addonConfig,
    required this.child,
  });

  final AddonConfig addonConfig;
  final Widget child;

  static AddonConfig of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_InheritedAddonConfig>();
    assert(result != null, 'No AddonsProvider found in context');
    return result!.addonConfig;
  }

  static List<Addon> addonsOf(BuildContext context) => of(context).addons;

  static Addon? addonByIdOf(
    BuildContext context,
    String addonId,
  ) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_InheritedAddonsById>();
    assert(result != null, 'No AddonsProvider found in context');
    return result!.addonsById[addonId];
  }

  static bool isAddonActiveOf(
    BuildContext context,
    String addonId,
  ) => addonByIdOf(context, addonId) != null;

  @override
  Widget build(BuildContext context) {
    return _InheritedAddonConfig(
      addonConfig: addonConfig,
      child: _InheritedAddonsById(
        addonsById: {
          for (final addon in addonConfig.addons) addon.id: addon,
        },
        child: child,
      ),
    );
  }
}

class _InheritedAddonConfig extends InheritedWidget {
  const _InheritedAddonConfig({
    required this.addonConfig,
    required super.child,
  });

  final AddonConfig addonConfig;

  @override
  bool updateShouldNotify(_InheritedAddonConfig oldWidget) {
    return oldWidget.addonConfig != addonConfig;
  }
}

class _InheritedAddonsById extends InheritedWidget {
  const _InheritedAddonsById({
    required this.addonsById,
    required super.child,
  });

  final Map<String, Addon> addonsById;

  @override
  bool updateShouldNotify(_InheritedAddonsById oldWidget) {
    return addonsById != oldWidget.addonsById;
  }
}
