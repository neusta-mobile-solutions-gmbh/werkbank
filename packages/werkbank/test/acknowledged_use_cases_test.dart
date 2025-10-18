import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:werkbank/src/global_state/global_state.dart';

void main() {
  group('AcknowledgedDescriptors', () {
    test('Serialization', () {
      final someTimestamp = DateTime.parse('2023-10-01T12:00:00Z');
      final useCaseEntry = AcknowledgedDescriptorEntry(
        path: 'path',
        firstSeen: someTimestamp,
        visitedCount: 0,
        availableSinceFirstStart: true,
      );

      final useCases = AcknowledgedDescriptors(
        entries: IList([useCaseEntry]),
      );

      final json = useCases.toJson();
      const expectedJson =
          '{"entries":[{"path":"path",'
          '"firstSeen":"2023-10-01T12:00:00.000Z",'
          '"visitedCount":0,'
          '"availableSinceFirstStart":true}]}';

      expect(json, expectedJson, reason: 'Serialization failed');

      final deserializedUseCases = AcknowledgedDescriptors.fromJson(json);

      expect(
        deserializedUseCases.entries.length,
        1,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedUseCases.entries.first.path,
        'path',
        reason: 'Deserialization failed',
      );
      expect(
        deserializedUseCases.entries.first.firstSeen,
        someTimestamp,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedUseCases.entries.first.visitedCount,
        0,
        reason: 'Deserialization failed',
      );
      expect(
        deserializedUseCases.entries.first.availableSinceFirstStart,
        true,
        reason: 'Deserialization failed',
      );

      expect(
        () => AcknowledgedDescriptors.fromJson(''),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => AcknowledgedDescriptors.fromJson('{'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      expect(
        () => AcknowledgedDescriptors.fromJson('{"things":[]}'),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
      const invalidJsonBrokenTimestamp =
          '{'
          '"entries":['
          '{"path":"path",'
          '"firstSeen":"20210-0:00.00Z",'
          '"visitedCount":0,'
          '"availableSinceFirstStart":true}'
          ']'
          '}';
      expect(
        () => AcknowledgedDescriptors.fromJson(invalidJsonBrokenTimestamp),
        throwsFormatException,
        reason: 'Deserialization failed',
      );
    });
  });
}
