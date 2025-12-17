import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/utils/utils.dart';

// TODO: Move somewhere else.
enum PanelTab { configure, inspect, settings }

// TODO: Move somewhere else.
class SectionsController extends GlobalStateController {
  static const _legacyTopLevelKey = 'tabs';
  static const _sectionIdOrderKey = 'sectionIdOrder';
  static const _hiddenSectionIdsKey = 'hiddenSectionIds';

  static String _keyForTab(PanelTab tab) => switch (tab) {
    PanelTab.configure => 'configure',
    PanelTab.inspect => 'inspect',
    PanelTab.settings => 'settings',
  };

  final Map<PanelTab, _SectionsData> _sectionsDataByTab = {
    for (final tab in PanelTab.values) tab: _SectionsData.empty,
  };

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    var effectiveJson = json;
    if (effectiveJson is! Map<String, Object?>) {
      return;
    }
    final legacyJson = effectiveJson[_legacyTopLevelKey];
    if (legacyJson is Map<String, Object?>) {
      effectiveJson = legacyJson;
    }

    for (final tab in PanelTab.values) {
      final tabJson = effectiveJson[_keyForTab(tab)];
      if (tabJson is Map<String, Object?>) {
        final sectionIdOrder = tabJson[_sectionIdOrderKey];
        final hiddenSectionIds = tabJson[_hiddenSectionIdsKey];
        if (sectionIdOrder is! List<Object?> ||
            hiddenSectionIds is! List<Object?>) {
          continue;
        }
        _sectionsDataByTab[tab] = _SectionsData(
          sectionIdOrder: sectionIdOrder.whereType<String>().toIList(),
          hiddenSectionIds: hiddenSectionIds.whereType<String>().toISet(),
        );
      }
    }
    notifyListeners();
  }

  @override
  Object? toJson() {
    return {
      for (final MapEntry(key: tab, value: sectionsData)
          in _sectionsDataByTab.entries)
        _keyForTab(tab): {
          _sectionIdOrderKey: sectionsData.sectionIdOrder.unlockView,
          _hiddenSectionIdsKey: sectionsData.hiddenSectionIds.toList(),
        },
    };
  }

  List<T> addAndOrderSections<T>({
    required PanelTab tab,
    required List<T> sections,
    required String Function(T) getId,
  }) {
    final sectionsData = _sectionsDataByTab[tab]!;
    final sectionOrder = sectionsData.sectionIdOrder;
    final newIds = sections.map(getId).toList();
    final newOrder = mergeOrderings(
      primary: sectionOrder.unlockView,
      secondary: newIds,
    );
    _sectionsDataByTab[tab] = sectionsData.copyWith(
      sectionIdOrder: newOrder.lockUnsafe,
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

  void reorder<T>({
    required PanelTab tab,
    required List<T> newSectionsOrder,
    required String Function(T) getId,
  }) {
    final sectionsData = _sectionsDataByTab[tab]!;
    _sectionsDataByTab[tab] = sectionsData.copyWith(
      sectionIdOrder: mergeOrderings(
        primary: newSectionsOrder.map(getId).toList(growable: false),
        secondary: sectionsData.sectionIdOrder.unlockView,
      ).lockUnsafe,
    );
    notifyListeners();
  }

  bool isVisible(PanelTab tab, String sectionId) {
    return !_sectionsDataByTab[tab]!.hiddenSectionIds.contains(sectionId);
  }

  void setVisibility(
    PanelTab tab,
    String sectionId, {
    required bool visible,
  }) {
    final sectionsData = _sectionsDataByTab[tab]!;
    _sectionsDataByTab[tab] = sectionsData.copyWith(
      hiddenSectionIds: visible
          ? sectionsData.hiddenSectionIds.remove(sectionId)
          : sectionsData.hiddenSectionIds.add(sectionId),
    );
    notifyListeners();
  }
}

@immutable
class _SectionsData {
  const _SectionsData({
    required this.sectionIdOrder,
    required this.hiddenSectionIds,
  });

  static const _SectionsData empty = _SectionsData(
    sectionIdOrder: IList<String>.empty(),
    hiddenSectionIds: ISet<String>.empty(),
  );

  final IList<String> sectionIdOrder;
  final ISet<String> hiddenSectionIds;

  _SectionsData copyWith({
    IList<String>? sectionIdOrder,
    ISet<String>? hiddenSectionIds,
  }) {
    return _SectionsData(
      sectionIdOrder: sectionIdOrder ?? this.sectionIdOrder,
      hiddenSectionIds: hiddenSectionIds ?? this.hiddenSectionIds,
    );
  }
}
