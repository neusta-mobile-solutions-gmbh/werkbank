import 'package:werkbank/src/persistence/src/history/werkbank_history.dart';
import 'package:werkbank/src/persistence/src/persistent_controller.dart';

abstract class HistoryController implements PersistentController {
  HistoryController();

  WerkbankHistory get unsafeHistory;

  void log(WerkbankHistoryEntry entry);
}
