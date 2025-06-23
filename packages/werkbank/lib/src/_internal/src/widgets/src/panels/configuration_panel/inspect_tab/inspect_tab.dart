import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class InspectTab extends StatelessWidget {
  const InspectTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabAddonControlSectionList(tab: PanelTab.inspect);
  }
}
