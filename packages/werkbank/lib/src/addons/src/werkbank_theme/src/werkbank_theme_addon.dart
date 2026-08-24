import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_applier.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/src/_internal/werkbank_theme_selector.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
class WerkbankThemeAddon extends Addon {
  const WerkbankThemeAddon() : super(id: addonId);

  static const addonId = 'werkbank_theme';

  @override
  void registerGlobalStateControllers(GlobalStateControllerRegistry registry) {
    registry.register(WerkbankThemeController.new);
  }

  @override
  AddonLayerEntries get layers => AddonLayerEntries(
    management: [
      ManagementLayerEntry(
        id: 'werkbank_theme_manager',
        appOnly: true,
        builder: (context, child) => WerkbankThemeApplier(
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
          const WerkbankThemeSelector(),
        ],
      ),
    ];
  }
}
