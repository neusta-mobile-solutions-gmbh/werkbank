import 'package:werkbank/src/persistence/persistence.dart';

abstract class HistoryController implements GlobalStateController {
  WerkbankHistory get unsafeHistory;

  void log(WerkbankHistoryEntry entry);
}
