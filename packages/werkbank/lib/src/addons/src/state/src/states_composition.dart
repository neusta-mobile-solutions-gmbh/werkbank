import 'package:werkbank/src/addons/src/state/src/_internal/buildable_state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_containers_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension StatesCompositionExtension on UseCaseComposition {
  StatesComposition get states => StatesComposition(this);
}

extension type StatesComposition(UseCaseComposition _composition) {
  StateContainersStateEntry get _stateEntry =>
      _composition.getTransientStateEntry<StateContainersStateEntry>();

  List<BuildableStateContainer<Object?>> get states =>
      _stateEntry.stateContainers;
}
