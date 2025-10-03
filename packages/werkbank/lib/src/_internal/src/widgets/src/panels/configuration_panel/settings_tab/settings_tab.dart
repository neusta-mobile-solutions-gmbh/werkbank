import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabAddonControlSectionList(tab: PanelTab.settings);
  }
}
