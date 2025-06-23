import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_manager.dart';
import 'package:werkbank/werkbank.dart';

class WerkbankThemeSelector extends StatelessWidget {
  const WerkbankThemeSelector({
    super.key,
    required this.themeNames,
  });

  final List<String> themeNames;

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.theming.controls.theme),
      control: WDropdown<String>(
        value: WerkbankThemeManager.themeNameOf(context),
        onChanged: (value) {
          WerkbankThemeManager.setThemeNameOf(
            context,
            value,
          );
        },
        items: [
          for (final themeName in themeNames)
            WDropdownMenuItem(
              value: themeName,
              child: Text(themeName),
            ),
        ],
      ),
    );
  }
}
