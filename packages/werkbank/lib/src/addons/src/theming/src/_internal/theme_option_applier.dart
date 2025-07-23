import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/theming/src/theming_addon.dart';
import 'package:werkbank/src/addons/src/theming/src/theming_manager.dart';

class ThemeOptionApplier extends StatelessWidget {
  const ThemeOptionApplier({
    super.key,
    required this.themeOptions,
    required this.child,
  });

  final List<ThemeOption> themeOptions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeOption = ThemingManager.selectedThemeOptionOf(context);
    var result = child;
    if (themeOption != null) {
      final wrapperBuilder = themeOption.wrapperBuilder;

      if (wrapperBuilder != null) {
        result = wrapperBuilder(context, result);
      }
    }
    return result;
  }
}
