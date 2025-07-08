import 'package:werkbank/src/addons/src/state/src/_internal/buildable_element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/elements_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension StatesCompositionExtension on UseCaseComposition {
  StatesComposition get states => StatesComposition(this);
}

extension type StatesComposition(UseCaseComposition _composition) {
  ElementsStateEntry get _stateEntry =>
      _composition.getTransientStateEntry<ElementsStateEntry>();

  List<BuildableElement<Object?>> get states => _stateEntry.elements;
}
