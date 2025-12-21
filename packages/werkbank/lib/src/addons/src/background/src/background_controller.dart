import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/background/background.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class BackgroundController extends GlobalStateController
    with ChangeNotifier, ListeningPersistedGlobalStateControllerMixin {
  late Map<String, BackgroundOption> _backgroundOptionsByName;
  late List<BackgroundOption> _availableBackgroundOptions;

  List<BackgroundOption> get availableBackgroundOptions =>
      _availableBackgroundOptions;

  BackgroundOption? backgroundOptionByName(String name) =>
      _backgroundOptionsByName[name];

  String? _selectedBackgroundOptionName;

  String? get selectedBackgroundOptionName => _selectedBackgroundOptionName;

  // TODO: Prevent setting to invalid option.
  set selectedBackgroundOptionName(String? name) {
    _selectedBackgroundOptionName = name;
    notifyListeners();
  }

  BackgroundOption? get selectedBackgroundOption {
    if (selectedBackgroundOptionName == null) {
      return null;
    }
    return _backgroundOptionsByName[selectedBackgroundOptionName!];
  }

  set selectedBackgroundOption(BackgroundOption? backgroundOption) =>
      selectedBackgroundOptionName = backgroundOption?.name;

  void updateBackgroundOptions(List<BackgroundOption> backgroundOptions) {
    _backgroundOptionsByName = {
      for (final backgroundOption in backgroundOptions)
        backgroundOption.name: backgroundOption,
    };
    _availableBackgroundOptions = UnmodifiableListView(backgroundOptions);
    if (selectedBackgroundOptionName != null &&
        !_backgroundOptionsByName.containsKey(selectedBackgroundOptionName)) {
      selectedBackgroundOptionName = backgroundOptions.firstOrNull?.name;
    }
  }

  @override
  Object? toJson() {
    return _selectedBackgroundOptionName;
  }

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      selectedBackgroundOptionName = json;
    }
  }
}

extension BackgroundGlobalStateExtension on GlobalState {
  BackgroundController get background => get<BackgroundController>();

  BackgroundController? get maybeBackground => maybeGet<BackgroundController>();
}
