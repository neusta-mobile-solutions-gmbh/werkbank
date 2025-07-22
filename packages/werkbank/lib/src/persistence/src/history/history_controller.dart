abstract class HistoryController implements PersistentController {
  HistoryController();

  WerkbankHistory get unsafeHistory;

  void log(WerkbankHistoryEntry entry);
}
