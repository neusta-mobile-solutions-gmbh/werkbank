import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

const _cappedHistorySize = 100;

class HistoryControllerImpl extends PersistentController
    implements HistoryController {
  HistoryControllerImpl({
    required super.prefsWithCache,
  });

  @override
  String get id => 'history';

  @override
  void init(String? unsafeJson) {
    try {
      _unsafeHistory = unsafeJson != null
          ? WerkbankHistory.fromJson(unsafeJson)
          : WerkbankHistory(
              entries: const IList<WerkbankHistoryEntry>.empty(),
            );
    } on FormatException {
      debugPrint(
        'Restoring WerkbankHistory failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
      _unsafeHistory = WerkbankHistory(
        entries: const IList<WerkbankHistoryEntry>.empty(),
      );
    }
  }

  late WerkbankHistory _unsafeHistory;

  @override
  // history can contain entries, that dont exist anylonger.
  // It is not the responsibility of the HistoryController
  // to validate the entries.
  // See RecentHistory for an example of how to handle this.
  WerkbankHistory get unsafeHistory => _unsafeHistory;

  @override
  void log(WerkbankHistoryEntry entry) {
    final entryIsNotDocumentedYet =
        unsafeHistory.currentEntry?.path != entry.path;
    if (entryIsNotDocumentedYet) {
      final cappedEntries = _unsafeHistory.entries.take(_cappedHistorySize - 1);
      _unsafeHistory = WerkbankHistory(
        entries: [
          entry,
          ...cappedEntries,
        ].lockUnsafe,
      );
    } else {
      final entriesExceptCurrent = _unsafeHistory.entries.sublist(1);
      _unsafeHistory = WerkbankHistory(
        entries: [
          entry,
          ...entriesExceptCurrent,
        ].lockUnsafe,
      );
    }

    setJson(
      _unsafeHistory.toJson(),
    );

    notifyListeners();
  }
}
