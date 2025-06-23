import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';

class SemanticsInspectorController {
  SemanticsInspectorController();

  final semanticsMonitorController = SemanticsMonitorController();

  final ValueNotifier<int?> _activeSemanticsNodeId = ValueNotifier(null);

  ValueListenable<int?> get activeSemanticsNodeId => _activeSemanticsNodeId;

  final ValueNotifier<ISet<int>> _hiddenSemanticsNodeIds = ValueNotifier(
    ISet(),
  );

  ValueListenable<ISet<int>> get hiddenSemanticsNodeIds =>
      _hiddenSemanticsNodeIds;

  // ignore: use_setters_to_change_properties
  void setActiveSemanticsNodeId(int? id) {
    _activeSemanticsNodeId.value = id;
  }

  void setSemanticsNodeHidden(
    int id, {
    required bool hidden,
  }) {
    final newHidden = hidden
        ? _hiddenSemanticsNodeIds.value.add(id)
        : _hiddenSemanticsNodeIds.value.remove(id);
    _hiddenSemanticsNodeIds.value = newHidden;
  }

  void dispose() {
    _activeSemanticsNodeId.dispose();
    _hiddenSemanticsNodeIds.dispose();
    semanticsMonitorController.dispose();
  }
}
