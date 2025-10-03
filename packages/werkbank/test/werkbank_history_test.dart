import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/src/global_state/global_state.dart';

void main() {
  group('WerkbankHistory', () {
    test('Serialization', () {
      final someTimestamp = DateTime.parse('2023-10-01T12:00:00Z');
      final historyEntry = WerkbankHistoryEntry(
        path: 'path',
        timestamp: someTimestamp,
      );

      final history = WerkbankHistory(
        entries: IList([historyEntry]),
      );

      final json = history.toJson();
      const expectedJson =
          '{"entries":[{"path":"path",'
          '"timestamp":"2023-10-01T12:00:00.000Z"}]}';

      expect(json, expectedJson, reason: 'Serialization failed');

      final deserializedHistory = WerkbankHistory.fromJson(json);

      expect(
        deserializedHistory.entries.length,
        1,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedHistory.entries.first.path,
        'path',
        reason: 'Deserialization failed',
      );
      expect(
        deserializedHistory.entries.first.timestamp,
        someTimestamp,
        reason: 'Deserialization failed',
      );

      expect(
        () => WerkbankHistory.fromJson(''),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => WerkbankHistory.fromJson('{'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => WerkbankHistory.fromJson('{"things":[]}'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      const invalidJsonBrokenTimestamp =
          '{"entries":[{"path":"path","timestamp":"20210-0:00.00Z"}]}';
      expect(
        () => WerkbankHistory.fromJson(invalidJsonBrokenTimestamp),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
    });
  });
}
