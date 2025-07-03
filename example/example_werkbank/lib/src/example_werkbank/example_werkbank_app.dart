import 'package:example_werkbank/src/example_werkbank/addon_config.dart';
import 'package:example_werkbank/src/example_werkbank/app_config.dart';
import 'package:example_werkbank/src/example_werkbank/use_cases/root.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class ExampleWerkbankApp extends StatelessWidget {
  const ExampleWerkbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WerkbankApp(
      name: 'Example Werkbank',
      logo: const FlutterLogo(),
      appConfig: appConfig,
      addonConfig: addonConfig,
      root: root,
    );
  }
}
