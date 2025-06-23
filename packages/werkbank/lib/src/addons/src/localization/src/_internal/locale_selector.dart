import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

class LocaleSelector extends StatelessWidget {
  const LocaleSelector({
    super.key,
    required this.locales,
  });

  final List<Locale> locales;

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.localization.controls.locale),
      control: WDropdown<Locale>(
        value: LocalizationManager.selectedLocaleOf(context),
        onChanged: (value) {
          LocalizationManager.setSelectedLocale(
            context,
            locale: value,
          );
        },
        items: [
          for (final locale in locales)
            WDropdownMenuItem(
              value: locale,
              child: Text(
                locale.toLanguageTag(),
              ),
            ),
        ],
      ),
    );
  }
}
