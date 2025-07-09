import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_manager.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_selector.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
class WerkbankThemeAddon extends Addon {
  const WerkbankThemeAddon() : super(id: addonId);

  static const addonId = 'werkbank_theme';

  static const List<String> _themeNames = [
    'Werkbank Light',
    'Werkbank Dark',
    'Werkbank System',
  ];

  @override
  ControllerMapFactory get controllerMapFactory =>
      (prefsWithCache) => {
        WerkbankThemePersistentController: WerkbankThemePersistentController(
          prefsWithCache: prefsWithCache,
        ),
      };

  @override
  AddonLayerEntries get layers => AddonLayerEntries(
    management: [
      ManagementLayerEntry(
        id: 'werkbank_theme_manager',
        appOnly: true,
        builder: (context, child) => WerkbankThemeManager(
          child: child,
        ),
      ),
    ],
  );

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    return [
      SettingsControlSection(
        id: 'werkbank_theme',
        sortHint: SortHint.afterMost,
        title: Text(context.sL10n.addons.werkbank_theme.name),
        children: [
          const WerkbankThemeSelector(themeNames: _themeNames),
        ],
      ),
    ];
  }
}
