import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/src/werkbank_internal.dart';

void main() {
  group('PanelTabsPersistentData', () {
    test('Serialization', () {
      final tabSectionData = TabSectionData(
        sectionIdOrder: ['tags', 'about', 'links'].lockUnsafe,
        hiddenSectionIds: {'about'}.lockUnsafe,
      );
      final tabs = IMap<PanelTab, TabSectionData>({
        PanelTab.inspect: tabSectionData,
      });

      final data = PanelTabsPersistentData(tabs: tabs);

      final json = jsonEncode(data.toJson());
      const expectedJson =
          '{"tabs":{"inspect":{"sectionIdOrder":["tags","about","links"],'
          '"hiddenSectionIds":["about"]}}}';

      expect(json, expectedJson, reason: 'Serialization failed');

      final deserializedData = PanelTabsPersistentData.fromJson(
        jsonDecode(json),
      );

      expect(
        deserializedData.tabs.length,
        3,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedData.tabs[PanelTab.inspect]!.sectionIdOrder,
        ['tags', 'about', 'links'],
        reason: 'Deserialization failed',
      );
      expect(
        deserializedData.tabs[PanelTab.inspect]!.hiddenSectionIds,
        {'about'},
        reason: 'Deserialization failed',
      );

      expect(
        () => PanelTabsPersistentData.fromJson(''),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => PanelTabsPersistentData.fromJson('{'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => PanelTabsPersistentData.fromJson('{"things":[]}'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      const invalidJsonBrokenEntry =
          '{"tabs":{"inspect":{"sectionIdOrder":["tags","about","links"],'
          '"hiddenSectionIds":[1]}';
      expect(
        () => PanelTabsPersistentData.fromJson(invalidJsonBrokenEntry),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
    });
  });
}
