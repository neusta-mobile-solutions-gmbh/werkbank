import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class WerkbankHistory {
  WerkbankHistory({
    required this.entries,
  });

  // Throws FormatException if the JSON is invalid or contains invalid data.
  static WerkbankHistory fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    if (map case {'entries': final List<dynamic> entries}) {
      return WerkbankHistory(
        entries: IList<WerkbankHistoryEntry>(
          entries.map((dynamic entry) {
            if (entry case {
              'path': final String path,
              'timestamp': final String timestamp,
            }) {
              return WerkbankHistoryEntry(
                path: path,
                timestamp: DateTime.parse(timestamp),
              );
            } else {
              throw const FormatException(
                'Invalid WerkbankHistoryEntry format',
              );
            }
          }),
        ),
      );
    } else {
      throw const FormatException('Invalid WerkbankHistory format');
    }
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'entries': entries.map((e) => e.toMap()).toList(),
    });
  }

  final IList<WerkbankHistoryEntry> entries;

  WerkbankHistoryEntry? get currentEntry =>
      entries.isNotEmpty ? entries.first : null;

  WerkbankHistoryEntry? get firstEntry =>
      entries.isNotEmpty ? entries.last : null;
}

class WerkbankHistoryEntry with EquatableMixin {
  WerkbankHistoryEntry({
    required this.path,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  final String path;
  final DateTime timestamp;

  @override
  String toString() =>
      'WerkbankHistoryEntry{path: $path, timestamp: $timestamp}';

  @override
  List<Object?> get props => [path, timestamp];
}
