import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:werkbank/werkbank.dart';

AddonConfig get addonConfig => AddonConfig(
  addons: [
    ThemingAddon(
      themeOptions: [
        ThemeOption.material(
          name: 'Pink',
          themeDataBuilder: (context) => ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
            ),
          ),
          wrapperBuilder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(platformBrightness: Brightness.light),
              child: child,
            );
          },
        ),
        ThemeOption.material(
          name: 'Blue',
          themeDataBuilder: (context) => ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
            ),
          ),
          wrapperBuilder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(platformBrightness: Brightness.light),
              child: child,
            );
          },
        ),
        ThemeOption.material(
          name: 'Amber Dark',
          themeDataBuilder: (context) => ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.dark,
              dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
            ),
          ),
          wrapperBuilder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(platformBrightness: Brightness.dark),
              child: child,
            );
          },
        ),
      ],
    ),
    BackgroundAddon(
      backgroundOptions: [
        BackgroundOption.colorBuilder(
          name: 'Surface',
          colorBuilder: (context) => Theme.of(context).colorScheme.surface,
        ),
      ],
    ),
    LocalizationAddon(
      locales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    ),
    const ReportAddon(
      reports: {
        PermanentReport(
          id: 'welcome',
          title: 'Welcome to the Example Werkbank',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WMarkdown(
                data:
                    'This is a an example Werkbank showcasing many of the '
                    'features.\n'
                    '\n'
                    'The use cases have **descriptions** in the **"INSPECT" '
                    'tab** which highlight '
                    'some of the noteworthy **Werkbank features** utilized '
                    'by the use case.',
              ),
              SizedBox(height: 16),
              Icon(Icons.arrow_upward_rounded, size: 24),
              Center(
                child: WMarkdown(data: 'Read above!'),
              ),
              SizedBox(height: 16),
              Center(
                child: WMarkdown(
                  data: 'Also scroll down (especially for shortcuts)',
                ),
              ),
              Icon(Icons.arrow_downward_rounded, size: 24),
            ],
          ),
          sortHint: SortHint(-10000000),
        ),
      },
    ),
  ],
);
