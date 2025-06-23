import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.themeOptions,
  });

  final List<ThemeOption> themeOptions;

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.theming.controls.theme),
      control: WDropdown<String?>(
        value: ThemingManager.selectedThemeOptionOf(context)?.name,
        onChanged: (value) {
          ThemingManager.setSelectedThemeName(
            context,
            value!,
          );
        },
        items: [
          for (final themeOption in themeOptions)
            WDropdownMenuItem(
              value: themeOption.name,
              child: Text(themeOption.name),
            ),
        ],
      ),
    );
  }
}
