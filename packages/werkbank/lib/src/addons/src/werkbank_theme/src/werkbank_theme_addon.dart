import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_manager.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_selector.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
class WerkbankThemeAddon extends Addon {
  const WerkbankThemeAddon() : super(id: addonId);

  static const addonId = 'werkbank_theme';

  static const lightThemeName = 'Werkbank Light';
  static const darkThemeName = 'Werkbank Dark';
  static const systemThemeName = 'Werkbank System';

  static const List<String> _themeNames = [
    lightThemeName,
    darkThemeName,
    systemThemeName,
  ];

  @override
  void registerPersistentControllers(GlobalStateControllerRegistry registry) {
    registry.register('werkbank_theme', WerkbankThemePersistentController.new);
  }

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
