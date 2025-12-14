import 'dart:collection';

import 'package:werkbank/src/addons/src/theming/theming.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class ThemeController extends GlobalStateController {
  late Map<String, ThemeOption> _themeOptionsByName;
  late List<ThemeOption> _availableThemeOptions;

  List<ThemeOption> get availableThemOptions => _availableThemeOptions;

  ThemeOption? themeOptionByName(String name) => _themeOptionsByName[name];

  String? _selectedThemeOptionName;

  String? get selectedThemeOptionName => _selectedThemeOptionName;

  // TODO: Prevent setting to invalid option.
  set selectedThemeOptionName(String? name) {
    _selectedThemeOptionName = name;
    notifyListeners();
  }

  ThemeOption? get selectedThemeOption {
    if (selectedThemeOptionName == null) {
      return null;
    }
    return _themeOptionsByName[selectedThemeOptionName!];
  }

  set selectedThemeOption(ThemeOption? themeOption) =>
      selectedThemeOptionName = themeOption?.name;

  void updateThemeOptions(List<ThemeOption> themeOptions) {
    _themeOptionsByName = {
      for (final themeOption in themeOptions) themeOption.name: themeOption,
    };
    _availableThemeOptions = UnmodifiableListView(themeOptions);
    if (selectedThemeOptionName == null ||
        !_themeOptionsByName.containsKey(selectedThemeOptionName)) {
      selectedThemeOptionName = themeOptions.firstOrNull?.name;
    }
  }

  @override
  Object? toJson() {
    return _selectedThemeOptionName;
  }

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      selectedThemeOptionName = json;
    }
  }
}
