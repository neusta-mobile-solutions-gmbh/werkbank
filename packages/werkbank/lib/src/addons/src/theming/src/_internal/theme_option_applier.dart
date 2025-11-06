import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/theming/theming.dart';

class ThemeOptionApplier extends StatelessWidget {
  const ThemeOptionApplier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeController = SettingsControlSection.access
        .globalStateControllerOf<ThemeController>(
          context,
        );
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final themeOption = themeController.selectedThemeOption;
        var result = child;
        if (themeOption != null) {
          final wrapperBuilder = themeOption.wrapperBuilder;

          if (wrapperBuilder != null) {
            result = wrapperBuilder(context, result);
          }
        }
        return result;
      },
    );
  }
}
