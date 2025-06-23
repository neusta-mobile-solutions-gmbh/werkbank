import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_persistent_data.dart';

void main() {
  group('ReportPersistentData', () {
    test('Serialization', () {
      const reportEntry = ReportEntry(
        accepted: true,
      );
      final entries = IMap<ReportId, ReportEntry>(const {
        'report1': reportEntry,
      });

      final data = ReportPersistentData(
        entries: entries,
        firstTimeReportAddonWasExecuted: DateTime(2020),
      );

      final json = data.toJson();
      const expectedJson =
          '{"entries":{"report1":{"accepted":true}},'
          '"firstTimeReportAddonWasExecuted":"2020-01-01T00:00:00.000"}';

      expect(json, expectedJson, reason: 'Serialization failed');

      final deserializedData = ReportPersistentData.fromJson(json);

      expect(
        deserializedData.entries.length,
        1,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedData.entries['report1']!.accepted,
        true,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedData.firstTimeReportAddonWasExecuted,
        DateTime(2020),
        reason: 'Deserialization failed',
      );

      expect(
        () => ReportPersistentData.fromJson(''),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => ReportPersistentData.fromJson('{'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => ReportPersistentData.fromJson('{"things":[]}'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      const invalidJsonBrokenEntry =
          '{"entries":{"report1":{"accepted":"notABool"}}}';
      expect(
        () => ReportPersistentData.fromJson(invalidJsonBrokenEntry),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
    });
  });
}
