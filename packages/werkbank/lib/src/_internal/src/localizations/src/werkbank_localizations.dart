import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/src/strings.g.dart';

export 'package:werkbank/src/_internal/src/localizations/src/strings.g.dart';

class WerkbankLocalizations {
  WerkbankLocalizations(this.translations);

  static WerkbankLocalizations of(BuildContext context) {
    return Localizations.of<WerkbankLocalizations>(
      context,
      WerkbankLocalizations,
    )!;
  }

  static const LocalizationsDelegate<WerkbankLocalizations> delegate =
      _WerkbankLocalizationsDelegate();

  Translations translations;
}

extension WerkbankTranslations on BuildContext {
  Translations get sL10n => WerkbankLocalizations.of(this).translations;
}

class _WerkbankLocalizationsDelegate
    extends LocalizationsDelegate<WerkbankLocalizations> {
  const _WerkbankLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final languageCode = locale.languageCode;
    return AppLocaleUtils.instance.locales.any(
      (al) => al.languageCode == languageCode,
    );
  }

  @override
  Future<WerkbankLocalizations> load(Locale locale) async {
    final languageCode = locale.languageCode;
    final languageTag = locale.toLanguageTag();
    Translations translations;
    var appLocales = AppLocaleUtils.instance.locales
        .where((al) => al.languageCode == languageCode)
        .toList();
    var showError = false;
    if (appLocales.isEmpty) {
      showError = true;
      appLocales = [AppLocaleUtils.instance.baseLocale];
    }
    var appLocale = appLocales
        .where((al) => al.languageTag == languageTag)
        .firstOrNull;
    if (appLocale == null) {
      showError = true;
      appLocale = appLocales.first;
    }
    if (showError) {
      log(
        'The locale "$locale" is not supported. '
        'Falling back to "${appLocale.languageTag}"',
        level: 900,
      );
    }
    translations = appLocale.buildSync();
    return SynchronousFuture<WerkbankLocalizations>(
      WerkbankLocalizations(translations),
    );
  }

  @override
  bool shouldReload(_WerkbankLocalizationsDelegate old) => false;
}
