import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_controller.dart';
import 'package:werkbank/werkbank.dart';

class AccessibilityStateEntry
    extends RetainedUseCaseStateEntry<AccessibilityStateEntry> {
  final SemanticsInspectorController controller =
      SemanticsInspectorController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
