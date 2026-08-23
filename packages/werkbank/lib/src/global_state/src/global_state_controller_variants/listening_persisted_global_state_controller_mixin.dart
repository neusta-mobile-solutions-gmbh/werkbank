import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: document
mixin ListeningPersistedGlobalStateControllerMixin
    on GlobalStateController, Listenable
    implements PersistedGlobalStateControllerMixin {
  @override
  Listenable get jsonChangedListenable => this;
}
