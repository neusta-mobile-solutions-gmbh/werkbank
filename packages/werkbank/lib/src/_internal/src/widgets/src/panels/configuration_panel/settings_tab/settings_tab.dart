import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabAddonControlSectionList(tab: PanelTab.settings);
  }
}
