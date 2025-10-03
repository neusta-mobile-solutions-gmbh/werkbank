import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_data.dart';

void main() {
  group('ReportData', () {
    test('Serialization', () {
      const reportEntry = ReportEntry(
        accepted: true,
      );
      final entries = IMap<ReportId, ReportEntry>(const {
        'report1': reportEntry,
      });

      final data = ReportData(
        entries: entries,
        firstTimeReportAddonWasExecuted: DateTime(2020),
      );

      final json = data.toJson();
      const expectedJson =
          '{"entries":{"report1":{"accepted":true}},'
          '"firstTimeReportAddonWasExecuted":"2020-01-01T00:00:00.000"}';

      expect(json, expectedJson, reason: 'Serialization failed');

      final deserializedData = ReportData.fromJson(json);

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
        () => ReportData.fromJson(''),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => ReportData.fromJson('{'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => ReportData.fromJson('{"things":[]}'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      const invalidJsonBrokenEntry =
          '{"entries":{"report1":{"accepted":"notABool"}}}';
      expect(
        () => ReportData.fromJson(invalidJsonBrokenEntry),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
    });
  });
}
