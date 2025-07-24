import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holders_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_management_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension StatesCompositionExtension on UseCaseComposition {
  StatesComposition get states => StatesComposition(this);
}

extension type StatesComposition(UseCaseComposition _composition) {
  Map<ImmutableStateId, ValueNotifier<Object?>> get immutable => _composition
      .getTransientStateEntry<ImmutableStateHoldersStateEntry>()
      .stateHolders;

  Map<MutableStateId, ValueContainer<Object?>> get mutable => _composition
      .getTransientStateEntry<MutableStateManagementStateEntry>()
      .stateHolders;
}
