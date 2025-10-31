import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/utils/utils.dart';

class TabAddonControlSectionList extends StatelessWidget {
  const TabAddonControlSectionList({
    super.key,
    required this.tab,
  });

  final PanelTab tab;

  @override
  Widget build(BuildContext context) {
    return _AddonControlSectionList(
      tab: tab,
      addonControlSections: [
        for (final addon in AddonConfigProvider.addonsOf(context))
          for (final section in switch (tab) {
            PanelTab.configure => addon.buildConfigureTabControlSections(
              context,
            ),
            PanelTab.inspect => addon.buildInspectTabControlSections(context),
            PanelTab.settings => addon.buildSettingsTabControlSections(context),
          })
            _AddonControlSectionWithAddonId(
              addonId: addon.id,
              addonControlSection: section,
            ),
      ],
    );
  }
}

class _AddonControlSectionWithAddonId {
  const _AddonControlSectionWithAddonId({
    required this.addonId,
    required this.addonControlSection,
  });

  final String addonId;
  final AddonControlSection addonControlSection;

  String get id => '$addonId-${addonControlSection.id}';

  SortHint get sortHint => addonControlSection.sortHint;
}

class _AddonControlSectionList extends StatefulWidget {
  const _AddonControlSectionList({
    required this.tab,
    required this.addonControlSections,
  });

  final PanelTab tab;
  final List<_AddonControlSectionWithAddonId> addonControlSections;

  @override
  State<_AddonControlSectionList> createState() =>
      _AddonControlSectionListState();
}

class _AddonControlSectionListState extends State<_AddonControlSectionList> {
  List<_AddonControlSectionWithAddonId>? _orderedSections;
  late PanelTabsController _panelTabsController;

  void _updateSections() {
    final orderedList = widget.addonControlSections.toList()
      ..sort((a, b) => a.sortHint.compareTo(b.sortHint));

    setState(() {
      _orderedSections = _panelTabsController.addAndOrderSections(
        tab: widget.tab,
        sections: orderedList,
        getId: (section) => section.id,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _panelTabsController = GlobalStateManager.maybePanelTabsControllerOf(
      context,
    )!;
    if (_orderedSections == null) {
      _updateSections();
    }
  }

  @override
  void didUpdateWidget(_AddonControlSectionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.addonControlSections != widget.addonControlSections) {
      _updateSections();
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    // Flutter uses a weird definition of the new index.
    // For example if oldIndex == 2, both newIndex == 2 and newIndex == 3 will
    // not change the order.
    final fixedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    setState(() {
      _orderedSections!.move(oldIndex, fixedNewIndex);
    });
    _panelTabsController.reorder(
      tab: widget.tab,
      newSectionsOrder: _orderedSections!,
      getId: (s) => s.id,
    );
  }

  void onToggleVisibility(int index) {
    final section = _orderedSections![index];
    setState(() {
      _panelTabsController.setVisibility(
        widget.tab,
        section.id,
        visible: !_panelTabsController.isVisible(widget.tab, section.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WControlSectionList(
      sections: [
        for (final section in _orderedSections!)
          ControlSection(
            id: section.id,
            title: section.addonControlSection.title,
            visible: _panelTabsController.isVisible(widget.tab, section.id),
            children: section.addonControlSection.children,
          ),
      ],
      onReorder: onReorder,
      onToggleVisibility: onToggleVisibility,
    );
  }
}
