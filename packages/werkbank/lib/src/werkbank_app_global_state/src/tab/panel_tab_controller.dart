import 'package:werkbank/src/global_state/global_state.dart';

enum PanelTab { configure, inspect, settings }

class PanelTabController extends GlobalStateController {
  PanelTab _selectedTab = PanelTab.configure;

  PanelTab get selectedTab => _selectedTab;

  set selectedTab(PanelTab value) {
    _selectedTab = value;
    notifyListeners();
  }

  @override
  Object? toJson() => switch (selectedTab) {
    PanelTab.configure => 'configure',
    PanelTab.inspect => 'inspect',
    PanelTab.settings => 'settings',
  };

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      selectedTab = switch (json) {
        'configure' => PanelTab.configure,
        'inspect' => PanelTab.inspect,
        'settings' => PanelTab.settings,
        _ => selectedTab,
      };
    }
  }
}
