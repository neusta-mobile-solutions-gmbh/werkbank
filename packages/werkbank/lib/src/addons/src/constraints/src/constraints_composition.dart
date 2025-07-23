import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_state_entry.dart';
import 'package:werkbank/src/addons/src/constraints/src/selectable_view_constraints_presets.dart';
import 'package:werkbank/src/addons/src/constraints/src/view_constraints.dart';
import 'package:werkbank/src/use_case/use_case.dart';

extension ConstraintsCompositionExtension on UseCaseComposition {
  ConstraintsComposition get constraints => ConstraintsComposition(this);
}

extension type ConstraintsComposition(UseCaseComposition _composition) {
  ConstraintsStateEntry get _stateEntry =>
      _composition.getTransientStateEntry<ConstraintsStateEntry>();

  ValueNotifier<ViewConstraints> get viewConstraintsNotifier =>
      _stateEntry.viewConstraintsNotifier;

  ValueListenable<Size?> get sizeListenable => _stateEntry.sizeNotifier;

  ValueListenable<SelectableViewConstraintsPreset?>
  get activeViewConstraintsPresetListenable =>
      _stateEntry.activeViewConstraintsPresetNotifier;

  void loadPreset(SelectableViewConstraintsPreset preset) {
    _stateEntry.loadPreset(preset);
  }
}
