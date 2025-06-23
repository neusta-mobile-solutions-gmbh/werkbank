import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class AcknowledgedDescriptors {
  AcknowledgedDescriptors({
    required this.entries,
  });

  AcknowledgedDescriptors.fromPaths(Set<String> validPaths)
    : entries = IList<AcknowledgedDescriptorEntry>(
        validPaths.map(
          (path) => AcknowledgedDescriptorEntry(
            path: path,
            firstSeen: DateTime.now(),
            visitedCount: 0,
            availableSinceFirstStart: true,
          ),
        ),
      );

  // Throws FormatException if the JSON is invalid or contains invalid data.
  static AcknowledgedDescriptors fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    if (map case {'entries': final List<dynamic> entries}) {
      return AcknowledgedDescriptors(
        entries: IList<AcknowledgedDescriptorEntry>(
          entries.map((dynamic entry) {
            if (entry case {
              'path': final String path,
              'firstSeen': final String firstSeen,
              'visitedCount': final int visitedCount,
              'availableSinceFirstStart': final bool availableSinceFirstStart,
            }) {
              return AcknowledgedDescriptorEntry(
                path: path,
                firstSeen: DateTime.parse(firstSeen),
                visitedCount: visitedCount,
                availableSinceFirstStart: availableSinceFirstStart,
              );
            } else {
              throw const FormatException(
                'Invalid AcknowledgedDescriptorEntry format',
              );
            }
          }),
        ),
      );
    } else {
      throw const FormatException('Invalid AcknowledgedDescriptors format');
    }
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'entries': entries.map((e) => e.toMap()).toList(),
    });
  }

  final IList<AcknowledgedDescriptorEntry> entries;
}

class AcknowledgedDescriptorEntry {
  AcknowledgedDescriptorEntry({
    required this.path,
    required this.firstSeen,
    required this.visitedCount,
    required this.availableSinceFirstStart,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'firstSeen': firstSeen.toIso8601String(),
      'visitedCount': visitedCount,
      'availableSinceFirstStart': availableSinceFirstStart,
    };
  }

  final String path;
  final DateTime firstSeen;
  final int visitedCount;
  final bool availableSinceFirstStart;

  bool get acknowledged => visitedCount > 0 && !availableSinceFirstStart;

  @override
  String toString() =>
      'AcknowledgedDescriptorEntry{'
      'path: $path, '
      'firstSeen: $firstSeen, '
      'visitedCount: $visitedCount, '
      'availableSinceFirstStart: $availableSinceFirstStart}';

  AcknowledgedDescriptorEntry copyWith({
    String? path,
    DateTime? firstSeen,
    int? visitedCount,
    bool? availableSinceFirstStart,
  }) {
    return AcknowledgedDescriptorEntry(
      path: path ?? this.path,
      firstSeen: firstSeen ?? this.firstSeen,
      visitedCount: visitedCount ?? this.visitedCount,
      availableSinceFirstStart:
          availableSinceFirstStart ?? this.availableSinceFirstStart,
    );
  }
}
