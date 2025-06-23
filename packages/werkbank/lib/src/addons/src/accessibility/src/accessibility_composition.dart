import 'package:werkbank/src/addons/src/accessibility/src/_internal/accessibility_state_entry.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_controller.dart';
import 'package:werkbank/werkbank.dart';

extension AccessibilityCompositionExtension on UseCaseComposition {
  AccessibilityComposition get accessibility => AccessibilityComposition(this);
}

extension type AccessibilityComposition(UseCaseComposition _composition) {
  SemanticsInspectorController get semanticsInspectorController =>
      _composition.getRetainedStateEntry<AccessibilityStateEntry>().controller;
}
