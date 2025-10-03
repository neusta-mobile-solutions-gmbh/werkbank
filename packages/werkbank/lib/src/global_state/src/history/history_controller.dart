import 'package:werkbank/src/global_state/global_state.dart';

abstract class HistoryController implements GlobalStateController {
  WerkbankHistory get unsafeHistory;

  void log(WerkbankHistoryEntry entry);
}
