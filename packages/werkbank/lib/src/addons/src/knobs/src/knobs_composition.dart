import 'package:flutter/foundation.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/knobs_state_entry.dart';
import 'package:werkbank/werkbank_old.dart';

extension KnobsCompositionExtension on UseCaseComposition {
  KnobsComposition get knobs => KnobsComposition(this);
}

extension type KnobsComposition(UseCaseComposition _composition) {
  KnobsStateEntry get _stateEntry =>
      _composition.getTransientStateEntry<KnobsStateEntry>();

  ValueListenable<KnobPreset?> get activeKnobPresetListenable =>
      _stateEntry.activeKnobPresetNotifier;

  List<BuildableKnob<Object?>> get knobs => _stateEntry.knobs;

  void loadPreset(KnobPreset preset) {
    _stateEntry.loadPreset(preset);
  }
}
