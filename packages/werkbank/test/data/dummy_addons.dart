import 'package:material_ui/material_ui.dart';
import 'package:werkbank/werkbank.dart';

AddonConfig get dummyAddons => AddonConfig(
  addons: [
    ThemingAddon(
      themeOptions: [
        ThemeOption.material(
          name: 'Default',
          themeDataBuilder: (context) => ThemeData.light(),
        ),
      ],
    ),
    LocalizationAddon(
      locales: const [
        Locale('en'),
      ],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    ),
  ],
);
