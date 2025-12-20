import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/components/components.dart';

class WerkbankThemeSelector extends StatelessWidget {
  const WerkbankThemeSelector({
    super.key,
  });

  static const List<WerkbankTheme> themes = [
    WerkbankTheme.system,
    WerkbankTheme.light,
    WerkbankTheme.dark,
  ];

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
          return WDropdown<WerkbankTheme>(
            value: werkbankThemeController.theme,
            onChanged: (value) {
              werkbankThemeController.theme = value;
            },
            items: [
              for (final theme in themes)
                WDropdownMenuItem(
                  value: theme,
                  child: Text(switch (theme) {
                    WerkbankTheme.light =>
                      context.sL10n.addons.werkbank_theme.themes.light,
                    WerkbankTheme.dark =>
                      context.sL10n.addons.werkbank_theme.themes.dark,
                    WerkbankTheme.system =>
                      context.sL10n.addons.werkbank_theme.themes.system,
                  }),
                ),
            ],
          );
        },
      ),
    );
  }
}
