import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

enum PanelTab {
  configure('configure'),
  inspect('inspect'),
  settings('settings');

  const PanelTab(this._jsonKey);

  final String _jsonKey;
}

class PanelTabsPersistentData {
  const PanelTabsPersistentData({required this.tabs});

  final IMap<PanelTab, TabSectionData> tabs;

  static PanelTabsPersistentData fromJson(Object? json) {
    if (json case {'tabs': final Map<String, dynamic> tabs}) {
      return PanelTabsPersistentData(
        tabs: {
          for (final tab in PanelTab.values)
            tab: TabSectionData.fromJson(
              (tabs[tab._jsonKey] ??
                      /* TODO(lzuttermeister): This is for backwards
                           compatibility. We can remove this later. */
                      switch (tab) {
                        PanelTab.configure => tabs['use_case'],
                        PanelTab.inspect => tabs['info'],
                        PanelTab.settings => null,
                      } ??
                      TabSectionData.empty.toJson())
                  as Map<String, dynamic>,
            ),
        }.lockUnsafe,
      );
    } else {
      throw const FormatException('Invalid PanelTabsPersistentData format');
    }
  }

  Object? toJson() {
    return {
      'tabs': {
        for (final entry in tabs.entries)
          entry.key._jsonKey: entry.value.toJson(),
      },
    };
  }

  PanelTabsPersistentData copyWith({
    IMap<PanelTab, TabSectionData>? tabs,
  }) {
    return PanelTabsPersistentData(
      tabs: tabs ?? this.tabs,
    );
  }
}

@immutable
class TabSectionData {
  const TabSectionData({
    required this.sectionIdOrder,
    required this.hiddenSectionIds,
  });

  static const TabSectionData empty = TabSectionData(
    sectionIdOrder: IList<String>.empty(),
    hiddenSectionIds: ISet<String>.empty(),
  );

  final IList<String> sectionIdOrder;
  final ISet<String> hiddenSectionIds;

  static TabSectionData fromJson(dynamic json) {
    if (json case {
      'sectionIdOrder': final List<dynamic> sectionIdOrder,
      'hiddenSectionIds': final List<dynamic> hiddenSectionIds,
    }) {
      return TabSectionData(
        sectionIdOrder: sectionIdOrder.cast<String>().lock,
        hiddenSectionIds: hiddenSectionIds.cast<String>().toISet(),
      );
    } else {
      throw const FormatException('Invalid TabSectionData format');
    }
  }

  dynamic toJson() {
    final map = <String, dynamic>{
      'sectionIdOrder': sectionIdOrder.unlockView,
      'hiddenSectionIds': hiddenSectionIds.toList(),
    };
    return map;
  }

  TabSectionData copyWith({
    IList<String>? sectionIdOrder,
    ISet<String>? hiddenSectionIds,
  }) {
    return TabSectionData(
      sectionIdOrder: sectionIdOrder ?? this.sectionIdOrder,
      hiddenSectionIds: hiddenSectionIds ?? this.hiddenSectionIds,
    );
  }
}
