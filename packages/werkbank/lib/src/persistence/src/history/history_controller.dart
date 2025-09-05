import 'package:werkbank/src/persistence/persistence.dart';

abstract class HistoryController implements PersistentController {
  WerkbankHistory get unsafeHistory;

  void log(WerkbankHistoryEntry entry);
}
