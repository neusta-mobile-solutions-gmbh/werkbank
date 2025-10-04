import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Normally werkbank does not export its localizations.
// The werkbank_werkbank has to make an exception here.
// ignore: implementation_imports
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/root.dart';

void main() {
  runApp(const WerkbankWerkbank());
}

AddonConfig get addons => AddonConfig(
  addons: [
    ThemingAddon(
      themeOptions: [
        ThemeOption.material(
          name: 'Light',
          themeDataBuilder: (context) => getThemeData(
            context,
            WerkbankTheme(
              colorScheme: WerkbankColorScheme.fromPalette(
                const WerkbankPalette.light(),
              ),
              textTheme: WerkbankTextTheme.standard(),
            ),
          ),
          wrapperBuilder: (context, child) => DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: WerkbankColorScheme.fromPalette(
                const WerkbankPalette.light(),
              ).text,
            ),
            child: child,
          ),
        ),
        ThemeOption.material(
          name: 'Dark',
          themeDataBuilder: (context) => getThemeData(
            context,
            WerkbankTheme(
              colorScheme: WerkbankColorScheme.fromPalette(
                const WerkbankPalette.dark(),
              ),
              textTheme: WerkbankTextTheme.standard(),
            ),
          ),
          wrapperBuilder: (context, child) => DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: WerkbankColorScheme.fromPalette(
                const WerkbankPalette.dark(),
              ).text,
            ),
            child: child,
          ),
        ),
      ],
      /* TODO(lzuttermeister): The names should start with "Theme: " but
               the dropdown causes problems with long names. Change this
               once we have our own dropdown. */
    ),
    BackgroundAddon(
      backgroundOptions: [
        BackgroundOption.colorBuilder(
          name: 'T: Surface',
          colorBuilder: (context) => context.werkbankColorScheme.surface,
        ),
        BackgroundOption.colorBuilder(
          name: 'T: Background',
          colorBuilder: (context) => context.werkbankColorScheme.background,
        ),
      ],
    ),
    LocalizationAddon(
      locales: const [
        Locale('en'),
      ],
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        WerkbankLocalizations.delegate,
      ],
    ),
    ReportAddon(
      reports: {
        AcceptableReport.markdown(
          id: 'werkbank_werkbank',
          title: 'Hello there 👋',
          markdown: '''
Your are looking at the Werkbank_Werkbank.
A special Werkbank just to test, demonstrate, document and highlight
all Werkbank features.
Have fun
''',
        ),
      },
    ),
  ],
);

class WerkbankWerkbank extends StatelessWidget {
  const WerkbankWerkbank({super.key});

  @override
  Widget build(BuildContext context) {
    const ciDate = String.fromEnvironment('last_updated_date');
    final lastUpdated = ciDate.isNotEmpty
        ? DateTime.parse(ciDate)
        : kDebugMode
        ? DateTime.now()
        : null;

    // Do use this project as an example of how to set up your Werkbank project.
    // Use the example_werkbank in the example directory instead.
    return WerkbankApp(
      name: 'Werkbank',
      logo: const WerkbankLogo(),
      lastUpdated: lastUpdated,
      appConfig: AppConfig.material(),
      root: root,
      addonConfig: addons,
    );
  }
}
