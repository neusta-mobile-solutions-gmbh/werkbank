import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/theming/theming.dart';
import 'package:werkbank/src/components/components.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.themeOptions,
  });

  final List<ThemeOption> themeOptions;

  @override
  Widget build(BuildContext context) {
    final themeController = SettingsControlSection.access
        .globalStateControllerOf<ThemeController>(
          context,
        );
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final selectedThemeOptionName = themeController.selectedThemeOptionName;
        return WControlItem(
          title: Text(context.sL10n.addons.theming.controls.theme),
          control: WDropdown<String?>(
            value: selectedThemeOptionName,
            onChanged: (value) {
              themeController.selectedThemeOptionName = value;
            },
            items: [
              if (selectedThemeOptionName == null)
                WDropdownMenuItem<String?>(
                  value: null,
                  child: Text(context.sL10n.addons.theming.controls.noTheme),
                ),
              for (final themeOption in themeOptions)
                WDropdownMenuItem(
                  value: themeOption.name,
                  child: Text(themeOption.name),
                ),
            ],
          ),
        );
      },
    );
  }
}
