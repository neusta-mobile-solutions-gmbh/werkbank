import 'package:flutter/material.dart';
import 'package:werkbank/src/theme/src/werkbank_theme.dart';

class WerkbankSettings extends StatelessWidget {
  const WerkbankSettings({
    super.key,
    this.orderOption,
    this.werkbankTheme,
    required this.child,
  }) : overwrite = false;

  const WerkbankSettings.overwrite({
    super.key,
    this.orderOption,
    this.werkbankTheme,
    required this.child,
  }) : overwrite = true;

  static OrderOption orderOptionOf(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_InheritedWerkbankSettings>(
          aspect: _WerkbankSettingsAspects.orderOption,
        );
    assert(result != null, 'No WerkbankSettings found in context');
    return result!.orderOption;
  }

  static WerkbankTheme werkbankThemeOf(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_InheritedWerkbankSettings>(
          aspect: _WerkbankSettingsAspects.werkbankTheme,
        );
    assert(result != null, 'No WerkbankSettings found in context');
    return result!.werkbankTheme;
  }

  final OrderOption? orderOption;
  final WerkbankTheme? werkbankTheme;
  final bool overwrite;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final OrderOption orderOption;
    final WerkbankTheme werkbankTheme;

    if (overwrite) {
      orderOption = this.orderOption!;
      werkbankTheme = this.werkbankTheme!;
    } else {
      final werkbankSettings = context
          .dependOnInheritedWidgetOfExactType<_InheritedWerkbankSettings>()!;
      orderOption = this.orderOption ?? werkbankSettings.orderOption;
      werkbankTheme = this.werkbankTheme ?? werkbankSettings.werkbankTheme;
    }

    return _InheritedWerkbankSettings(
      orderOption: orderOption,
      werkbankTheme: werkbankTheme,
      child: child,
    );
  }
}

enum OrderOption {
  code,
  alphabetic,
}

enum _WerkbankSettingsAspects {
  orderOption,
  werkbankTheme,
}

class _InheritedWerkbankSettings
    extends InheritedModel<_WerkbankSettingsAspects> {
  const _InheritedWerkbankSettings({
    required this.orderOption,
    required this.werkbankTheme,
    required super.child,
  });

  final OrderOption orderOption;
  final WerkbankTheme werkbankTheme;

  @override
  bool updateShouldNotify(_InheritedWerkbankSettings oldWidget) {
    return orderOption != oldWidget.orderOption ||
        werkbankTheme != oldWidget.werkbankTheme;
  }

  @override
  bool updateShouldNotifyDependent(
    _InheritedWerkbankSettings oldWidget,
    Set<_WerkbankSettingsAspects> dependencies,
  ) {
    return dependencies.contains(_WerkbankSettingsAspects.orderOption) &&
            orderOption != oldWidget.orderOption ||
        dependencies.contains(_WerkbankSettingsAspects.werkbankTheme) &&
            werkbankTheme != oldWidget.werkbankTheme;
  }
}
