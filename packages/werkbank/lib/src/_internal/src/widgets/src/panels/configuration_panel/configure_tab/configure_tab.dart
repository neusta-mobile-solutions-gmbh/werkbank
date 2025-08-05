import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/panels/configuration_panel/tab_addon_control_section_list.dart';
import 'package:werkbank/src/persistence/persistence.dart';

class ConfigureTab extends StatelessWidget {
  const ConfigureTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TabAddonControlSectionList(tab: PanelTab.configure);
  }
}
