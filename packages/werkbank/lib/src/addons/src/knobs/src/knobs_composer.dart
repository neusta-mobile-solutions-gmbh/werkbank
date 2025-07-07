import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/knobs_state_entry.dart';
import 'package:werkbank/werkbank.dart';

extension type KnobsComposer(UseCaseComposer _c) {
  void registerKnob(BuildableKnob<Object?> knob) {
    _c.getTransientStateEntry<KnobsStateEntry>().addKnob(knob);
  }
}

extension KnobsComposerExtension on UseCaseComposer {
  /// Returns a [KnobsComposer] with many methods to create knobs
  /// for the use case.
  KnobsComposer get knobs => KnobsComposer(this);

  void knobPreset(String name, VoidCallback setKnobs) {
    final preset = DefinedKnobPreset(name);
    getTransientStateEntry<KnobsStateEntry>().addPreset(preset, setKnobs);
    addSearchCluster(
      SearchCluster(
        semanticDescription: 'Knob Preset $name',
        field: 'kPreset',
        entries: [
          FuzzySearchEntry(searchString: preset.name),
        ],
      ),
    );
    final currentPresets =
        getMetadata<_KnobPresetsMetadataEntry>()?.knobPresets ??
        const IList.empty();
    setMetadata(_KnobPresetsMetadataEntry(currentPresets.add(preset)));
  }
}

extension KnobPresetsMetadataExtension on UseCaseMetadata {
  /// Returns all knob presets for this use case, starting with the
  /// [InitialKnobPreset].
  List<KnobPreset> get knobPresets => CombinedListView([
    const [InitialKnobPreset()],
    definedKnobPresets,
  ]);

  /// Returns all defined knob presets for this use case.
  List<DefinedKnobPreset> get definedKnobPresets =>
      (get<_KnobPresetsMetadataEntry>()?.knobPresets ?? const IList.empty())
          .unlockView;
}

class _KnobPresetsMetadataEntry
    extends UseCaseMetadataEntry<_KnobPresetsMetadataEntry> {
  const _KnobPresetsMetadataEntry(this.knobPresets);

  final IList<DefinedKnobPreset> knobPresets;
}
