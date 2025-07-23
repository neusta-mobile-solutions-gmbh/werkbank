import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/localization/src/localization_manager.dart';

class LocalizationsApplier extends StatelessWidget {
  const LocalizationsApplier({
    super.key,
    required this.localizationsDelegates,
    required this.child,
  });

  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedLocale = LocalizationManager.selectedLocaleOf(context);
    return Localizations.override(
      context: context,
      locale: selectedLocale,
      delegates: localizationsDelegates,
      child: child,
    );
  }
}
