import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/components/components.dart';

class WerkbankThemeSelector extends StatelessWidget {
  const WerkbankThemeSelector({
    super.key,
    required this.themeNames,
  });

  final List<String> themeNames;

  @override
  Widget build(BuildContext context) {
    final werkbankThemeController = SettingsControlSection.access
        .globalStateOf(context)
        .werkbankTheme;
    return WControlItem(
      title: Text(context.sL10n.addons.theming.controls.theme),
      control: ListenableBuilder(
        listenable: werkbankThemeController,
        builder: (context, _) {
          return WDropdown<String>(
            value: werkbankThemeController.themeName,
            onChanged: (value) {
              werkbankThemeController.themeName = value;
            },
            items: [
              for (final themeName in themeNames)
                WDropdownMenuItem(
                  value: themeName,
                  child: Text(themeName),
                ),
            ],
          );
        },
      ),
    );
  }
}
