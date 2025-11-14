import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class InspectTab extends StatelessWidget {
  const InspectTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabAddonControlSectionList(tab: PanelTab.inspect);
  }
}
