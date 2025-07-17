import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_containers_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension StatesCompositionExtension on UseCaseComposition {
  StatesComposition get states => StatesComposition(this);
}

extension type StatesComposition(UseCaseComposition _composition) {
  ImmutableStateContainersStateEntry get _stateEntry =>
      _composition.getTransientStateEntry<ImmutableStateContainersStateEntry>();

  List<ImmutableStateContainer<Object?>> get states =>
      _stateEntry.stateContainers;
}
