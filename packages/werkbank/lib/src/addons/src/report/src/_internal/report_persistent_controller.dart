import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/report/report.dart';
import 'package:werkbank/src/addons/src/report/src/_internal/report_persistent_data.dart';
import 'package:werkbank/src/persistence/persistence.dart';

class ReportPersistentController extends GlobalStateController {
  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    try {
      _persistentData = ReportPersistentData.fromJson(json);
      notifyListeners();
    } on FormatException {
      debugPrint(
        'Restoring ReportPersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
    }
  }

  @override
  Object? toJson() {
    return _persistentData.toJson();
  }

  ReportPersistentData _persistentData = ReportPersistentData(
    entries: <ReportId, ReportEntry>{}.lockUnsafe,
    firstTimeReportAddonWasExecuted: DateTime.now(),
  );

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
    notifyListeners();
  }
}
