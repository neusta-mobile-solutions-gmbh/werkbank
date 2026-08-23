import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: document
mixin SelfListeningPersistedGlobalStateControllerMixin
    on PersistedGlobalStateControllerMixin, Listenable {
  @override
  Listenable get jsonChangedListenable => this;
}
