import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class PanelTabsController extends PersistentController<PanelTabsController> {
  PanelTabsController() : super(id: 'panel_tabs');

  @override
  void tryLoadFromJson(Object? json) {
    // TODO: Rework this
    late final emptyDataObj = PanelTabsPersistentData(
      tabs: {
        for (final tab in PanelTab.values) tab: TabSectionData.empty,
      }.lockUnsafe,
    );
    try {
      _unsafePersistentData = json != null
          ? PanelTabsPersistentData.fromJson(json)
          : emptyDataObj;
      notifyListeners();
    } on FormatException catch (_) {
      debugPrint(
        'Restoring PanelTabsPersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
      _unsafePersistentData = emptyDataObj;
      notifyListeners();
    }
  }

  @override
  Object? toJson() {
    return _unsafePersistentData.toJson();
  }

  late PanelTabsPersistentData _unsafePersistentData;

  List<T> addAndOrderSections<T>(
    PanelTab tab,
    List<T> sections,
    String Function(T) getId,
  ) {
    final sectionData = _unsafePersistentData.tabs[tab]!;
    final sectionOrder = sectionData.sectionIdOrder;
    final newIds = sections.map(getId).toList();
    final newOrder = mergeOrderings(
      primary: sectionOrder.unlockView,
      secondary: newIds,
    );
    final newSectionData = sectionData.copyWith(
      sectionIdOrder: newOrder.lockUnsafe,
    );
    _unsafePersistentData = _unsafePersistentData.copyWith(
      tabs: _unsafePersistentData.tabs.add(tab, newSectionData),
    );
    notifyListeners();
    final orderedSections = <T>[];
    final sectionsById = {
      for (final section in sections) getId(section): section,
    };
    for (final id in newOrder) {
      final section = sectionsById[id];
      if (section != null) {
        orderedSections.add(section);
      }
    }
    return orderedSections;
  }

  void reorder(PanelTab tab, List<String> newOrder) {
    final sectionData = _unsafePersistentData.tabs[tab]!;
    final newSectionData = sectionData.copyWith(
      sectionIdOrder: mergeOrderings(
        primary: newOrder,
        secondary: sectionData.sectionIdOrder.unlockView,
      ).lockUnsafe,
    );
    _unsafePersistentData = _unsafePersistentData.copyWith(
      tabs: _unsafePersistentData.tabs.add(tab, newSectionData),
    );
    notifyListeners();
  }

  bool isVisible(PanelTab tab, String sectionId) {
    final sectionData = _unsafePersistentData.tabs[tab]!;
    return !sectionData.hiddenSectionIds.contains(sectionId);
  }

  void setVisibility(
    PanelTab tab,
    String sectionId, {
    required bool visible,
  }) {
    final sectionData = _unsafePersistentData.tabs[tab]!;
    final newSectionData = sectionData.copyWith(
      hiddenSectionIds: visible
          ? sectionData.hiddenSectionIds.remove(sectionId)
          : sectionData.hiddenSectionIds.add(sectionId),
    );
    _unsafePersistentData = _unsafePersistentData.copyWith(
      tabs: _unsafePersistentData.tabs.add(tab, newSectionData),
    );
    notifyListeners();
  }
}
