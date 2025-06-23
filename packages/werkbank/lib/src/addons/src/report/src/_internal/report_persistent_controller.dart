import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_persistent_data.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class ReportPersistentController extends PersistentController {
  ReportPersistentController({required super.prefsWithCache});

  @override
  String get id => 'report';

  @override
  void init(String? unsafeJson) {
    try {
      _persistentData = unsafeJson != null
          ? ReportPersistentData.fromJson(unsafeJson)
          : ReportPersistentData(
              entries: <ReportId, ReportEntry>{}.lockUnsafe,
              firstTimeReportAddonWasExecuted: DateTime.now(),
            );
    } on FormatException {
      debugPrint(
        'Restoring ReportPersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
      _persistentData = ReportPersistentData(
        entries: <ReportId, ReportEntry>{}.lockUnsafe,
        firstTimeReportAddonWasExecuted: DateTime.now(),
      );
    }
  }

  late ReportPersistentData _persistentData;

  ReportPersistentData get persistentData => _persistentData;

  void accept(Report report) {
    final reportEntry =
        _persistentData.entries[report.id]?.copyWith(
          accepted: true,
        ) ??
        const ReportEntry(
          accepted: true,
        );

    _persistentData = _persistentData.copyWith(
      entries: {
        ..._persistentData.entries.unlock,
        report.id: reportEntry,
      }.lockUnsafe,
    );
    setJson(
      _persistentData.toJson(),
    );

    notifyListeners();
  }
}
