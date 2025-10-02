import 'package:flutter/material.dart';

abstract class PersistentController extends ChangeNotifier {
  final _jsonChangedNotifier = _JsonChangedNotifier();

  /// A listenable that notifies its listeners if the value returned by
  /// [toJson] has changed.
  Listenable get jsonChangedListenable => _jsonChangedNotifier;

  void tryLoadFromJson(Object? json);

  Object? toJson();

  @override
  void notifyListeners({bool hasJsonChanged = true}) {
    super.notifyListeners();
    if (hasJsonChanged) {
      _jsonChangedNotifier.notifyPersistenceChanged();
    }
  }
}

class _JsonChangedNotifier extends ChangeNotifier {
  void notifyPersistenceChanged() {
    notifyListeners();
  }
}
