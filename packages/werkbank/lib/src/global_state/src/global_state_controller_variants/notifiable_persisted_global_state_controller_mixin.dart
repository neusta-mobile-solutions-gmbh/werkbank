import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: document
mixin NotifiablePersistedGlobalStateControllerMixin on GlobalStateController
    implements PersistedGlobalStateControllerMixin {
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
