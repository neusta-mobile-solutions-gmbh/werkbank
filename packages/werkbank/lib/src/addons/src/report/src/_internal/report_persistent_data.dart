import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

typedef ReportId = String;

class ReportPersistentData {
  const ReportPersistentData({
    required this.entries,
    required this.firstTimeReportAddonWasExecuted,
  });

  final IMap<ReportId, ReportEntry> entries;
  final DateTime firstTimeReportAddonWasExecuted;

  static ReportPersistentData fromJson(Object? json) {
    if (json case {
      'entries': final Map<String, dynamic> entries,
      'firstTimeReportAddonWasExecuted':
          final String firstTimeReportAddonWasExecuted,
    }) {
      return ReportPersistentData(
        entries: IMap(
          entries.map((key, value) {
            if (value is Map<String, dynamic>) {
              return MapEntry(
                key,
                ReportEntry.fromMap(value),
              );
            } else {
              throw const FormatException('Invalid ReportEntry format');
            }
          }),
        ),
        firstTimeReportAddonWasExecuted: DateTime.parse(
          firstTimeReportAddonWasExecuted,
        ),
      );
    } else {
      throw const FormatException('Invalid ReportPersistentData format');
    }
  }

  Object? toJson() {
    return <String, dynamic>{
      'entries': {
        ...entries.unlock.map(
          (key, value) => MapEntry(key, value.toMap()),
        ),
      },
      'firstTimeReportAddonWasExecuted': firstTimeReportAddonWasExecuted
          .toIso8601String(),
    };
  }

  ReportPersistentData copyWith({
    IMap<ReportId, ReportEntry>? entries,
    DateTime? firstTimeReportAddonWasExecuted,
  }) {
    return ReportPersistentData(
      entries: entries ?? this.entries,
      firstTimeReportAddonWasExecuted:
          firstTimeReportAddonWasExecuted ??
          this.firstTimeReportAddonWasExecuted,
    );
  }
}

class ReportEntry with EquatableMixin {
  const ReportEntry({
    required this.accepted,
  });

  factory ReportEntry.fromMap(Map<String, dynamic> map) {
    if (map case {
      'accepted': final bool accepted,
    }) {
      return ReportEntry(
        accepted: accepted,
      );
    } else {
      throw const FormatException('Invalid ReportEntry format');
    }
  }

  final bool accepted;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accepted': accepted,
    };
  }

  @override
  String toString() {
    return 'ReportEntry{accepted: $accepted}';
  }

  ReportEntry copyWith({
    bool? accepted,
  }) {
    return ReportEntry(
      accepted: accepted ?? this.accepted,
    );
  }

  @override
  List<Object?> get props => [
    accepted,
  ];
}
