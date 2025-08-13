import 'package:werkbank/src/persistence/persistence.dart';

abstract class HistoryController
    implements PersistentController<HistoryController> {
  HistoryController();

  WerkbankHistory get unsafeHistory;

  void log(WerkbankHistoryEntry entry);
}
