import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class WerkbankThemeController extends GlobalStateController {
  WerkbankThemeController();

  String _themeName = WerkbankThemeAddon.systemThemeName;

  String get themeName => _themeName;

  set themeName(String newThemeName) {
    if (_themeName != newThemeName) {
      _themeName = newThemeName;
      notifyListeners();
    }
  }

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      themeName = json;
    }
  }

  @override
  Object? toJson() {
    return themeName;
  }
}

extension WerkbankThemeGlobalStateExtension on GlobalState {
  WerkbankThemeController get werkbankTheme => get<WerkbankThemeController>();

  WerkbankThemeController? get maybeWerkbankTheme =>
      maybeGet<WerkbankThemeController>();
}
