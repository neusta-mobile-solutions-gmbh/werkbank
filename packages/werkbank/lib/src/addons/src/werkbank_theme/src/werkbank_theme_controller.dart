import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

enum WerkbankTheme {
  light,
  dark,
  system,
}

class WerkbankThemeController extends GlobalStateController
    with ChangeNotifier, ListeningPersistedGlobalStateControllerMixin {
  WerkbankThemeController();

  static const _lightThemeName = 'Werkbank Light';
  static const _darkThemeName = 'Werkbank Dark';
  static const _systemThemeName = 'Werkbank System';

  WerkbankTheme _theme = WerkbankTheme.system;

  WerkbankTheme get theme => _theme;

  set theme(WerkbankTheme newThemeName) {
    if (_theme != newThemeName) {
      _theme = newThemeName;
      notifyListeners();
    }
  }

  @override
  String get jsonStoreKey => 'werkbank_theme';

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      theme = switch (json) {
        _lightThemeName => WerkbankTheme.light,
        _darkThemeName => WerkbankTheme.dark,
        _systemThemeName => WerkbankTheme.system,
        _ => WerkbankTheme.system,
      };
    }
  }

  @override
  Object? toJson() {
    return switch (theme) {
      WerkbankTheme.light => _lightThemeName,
      WerkbankTheme.dark => _darkThemeName,
      WerkbankTheme.system => _systemThemeName,
    };
  }
}

extension WerkbankThemeGlobalStateExtension on GlobalState {
  WerkbankThemeController get werkbankTheme => get<WerkbankThemeController>();

  WerkbankThemeController? get maybeWerkbankThemeChoice =>
      maybeGet<WerkbankThemeController>();
}
