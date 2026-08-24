import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: Add second variant that also implements Listenable? Or do this here?
// TODO: document
mixin NotifiablePersistedGlobalStateControllerMixin
    on PersistedGlobalStateControllerMixin {
  final _jsonChangedNotifier = _JsonChangedNotifier();

  @override
  Listenable get jsonChangedListenable => _jsonChangedNotifier;

  void notifyJsonChanged() {
    _jsonChangedNotifier.notifyPersistenceChanged();
  }
}

class _JsonChangedNotifier extends ChangeNotifier {
  void notifyPersistenceChanged() {
    notifyListeners();
  }
}
