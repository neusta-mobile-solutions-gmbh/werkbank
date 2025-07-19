import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holders_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension StatesCompositionExtension on UseCaseComposition {
  StatesComposition get states => StatesComposition(this);
}

extension type StatesComposition(UseCaseComposition _composition) {
  ImmutableStateHoldersStateEntry get _stateEntry =>
      _composition.getTransientStateEntry<ImmutableStateHoldersStateEntry>();

  List<ValueNotifier<Object?>> get states => _stateEntry.stateHolders;
}
