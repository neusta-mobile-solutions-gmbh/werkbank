import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class WerkbankThemeApplier extends StatelessWidget {
  const WerkbankThemeApplier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);

    final werkbankThemeController = SettingsControlSection.access
        .globalStateOf(context)
        .werkbankTheme;
    return ListenableBuilder(
      listenable: werkbankThemeController,
      builder: (context, _) {
        final darkColorScheme = WerkbankColorScheme.fromPalette(
          const WerkbankPalette.dark(),
        );

        final lightColorScheme = WerkbankColorScheme.fromPalette(
          const WerkbankPalette.light(),
        );

        final themeName = werkbankThemeController.theme;
        return WerkbankSettings(
          orderOption: WerkbankSettings.orderOptionOf(context),
          werkbankTheme: switch (themeName) {
            WerkbankTheme.dark => WerkbankThemeData(
              colorScheme: darkColorScheme,
              textTheme: WerkbankTextTheme.standard(),
            ),
            WerkbankTheme.light => WerkbankThemeData(
              colorScheme: lightColorScheme,
              textTheme: WerkbankTextTheme.standard(),
            ),
            WerkbankTheme.system || _ => WerkbankThemeData(
              colorScheme: switch (brightness) {
                Brightness.dark => darkColorScheme,
                Brightness.light => lightColorScheme,
              },
              textTheme: WerkbankTextTheme.standard(),
            ),
          },
          child: child,
        );
      },
    );
  }
}
