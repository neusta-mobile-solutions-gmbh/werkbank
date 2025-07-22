import 'package:flutter/material.dart';

class ConfigureTab extends StatelessWidget {
  const ConfigureTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TabAddonControlSectionList(tab: PanelTab.configure);
  }
}
