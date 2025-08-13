import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/use_case/use_case.dart';

class KnobsStateEntry
    extends TransientUseCaseStateEntry<KnobsStateEntry, KnobsSnapshot> {
  final Map<KnobId, BuildableKnob<Object?>> _knobsById = {};

  final Map<String, _ExecutableKnobPreset> _presetsByName = {};

  final activeKnobPresetNotifier = ValueNotifier<KnobPreset?>(
    const InitialKnobPreset(),
  );

  void _setToNoPreset() {
    activeKnobPresetNotifier.value = null;
  }

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    for (final knob in _knobsById.values) {
      knob.prepareForBuild(context);
      // We don't need to remove the listener later, since the knob and
      // therefore its contentChangedListenable will be disposed when the
      // KnobsStateEntry is disposed.
      knob.contentChangedListenable.addListener(_setToNoPreset);
    }
  }

  @override
  Listenable? createRebuildListenable() {
    return Listenable.merge([
      for (final knob in _knobsById.values) knob.contentChangedListenable,
    ]);
  }

  void addKnob(BuildableKnob<Object?> knob) {
    assert(
      !_knobsById.containsKey(knob.id),
      'Knob with label "${knob.id}" already exists',
    );
    _knobsById[knob.id] = knob;
  }

  void addPreset(DefinedKnobPreset preset, VoidCallback setKnobs) {
    final name = preset.name;
    assert(
      !_presetsByName.containsKey(name),
      'Knob preset with name "$name" already exists',
    );
    _presetsByName[name] = _ExecutableKnobPreset(
      preset: preset,
      setKnobs: setKnobs,
    );
  }

  List<BuildableKnob<Object?>> get knobs =>
      UnmodifiableListView(_knobsById.values);

  void loadPreset(KnobPreset preset) {
    void resetToInitial() {
      for (final knob in knobs) {
        knob.resetToInitial();
      }
    }

    switch (preset) {
      case InitialKnobPreset():
        resetToInitial();
      case DefinedKnobPreset(:final name):
        final preset = _presetsByName[name];
        if (preset == null) {
          activeKnobPresetNotifier.value = null;
          return;
        }
        resetToInitial();
        preset.setKnobs();
    }
    // Since FocusNodes call their listeners async, we have to change
    // the selected preset after the focus has updated.
    // Otherwise FocusNodeKnobs wouldn't work correctly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!active) {
        return;
      }
      activeKnobPresetNotifier.value = preset;
    });
  }

  @override
  void loadSnapshot(KnobsSnapshot snapshot) {
    for (final knob in _knobsById.values) {
      if (snapshot.knobSnapshots.containsKey(knob.id)) {
        final knobSnapshot = snapshot.knobSnapshots[knob.id];
        if (knobSnapshot != null) {
          knob.tryLoadSnapshot(knobSnapshot);
        }
      }
    }

    final preset = snapshot.activePreset;
    if (preset != null) {
      loadPreset(preset);
    }
  }

  @override
  KnobsSnapshot saveSnapshot() {
    return KnobsSnapshot(
      knobSnapshots: {
        for (final MapEntry(:key, :value) in _knobsById.entries)
          key: value.createSnapshot(),
      }.lockUnsafe,
      activePreset: activeKnobPresetNotifier.value,
    );
  }

  @override
  void dispose() {
    activeKnobPresetNotifier.dispose();
    for (final knob in _knobsById.values) {
      knob.dispose();
    }
    super.dispose();
  }
}

class KnobsSnapshot extends TransientUseCaseStateSnapshot {
  const KnobsSnapshot({
    required this.knobSnapshots,
    required this.activePreset,
  });

  final IMap<KnobId, KnobSnapshot> knobSnapshots;
  final KnobPreset? activePreset;
}

class _ExecutableKnobPreset {
  _ExecutableKnobPreset({
    required this.preset,
    required this.setKnobs,
  });

  final DefinedKnobPreset preset;
  final VoidCallback setKnobs;
}
