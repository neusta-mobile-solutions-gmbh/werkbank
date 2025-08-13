import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/constraints/constraints.dart';
import 'package:werkbank/src/use_case/use_case.dart';

class ConstraintsStateEntry
    extends
        TransientUseCaseStateEntry<ConstraintsStateEntry, ConstraintsSnapshot> {
  ValueNotifier<ViewConstraints>? _viewConstraintsNotifier;

  ValueNotifier<ViewConstraints> get viewConstraintsNotifier =>
      _viewConstraintsNotifier!;

  final activeViewConstraintsPresetNotifier =
      ValueNotifier<SelectableViewConstraintsPreset?>(
        const InitialViewConstraintsPreset(),
      );
  ViewConstraints _initialViewConstraints = ViewConstraints.looseViewLimited;

  final Map<String, ViewConstraintsPreset> _viewConstraintsPresetsByName = {};

  ValueNotifier<Size?> sizeNotifier = ValueNotifier(null);

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    _viewConstraintsNotifier = _ViewConstraintsNotifier(
      initialValue: _initialViewConstraints,
      supportedSizes: composition.metadata.supportedSizes,
    );
    viewConstraintsNotifier.addListener(_resetViewConstraints);
  }

  void _resetViewConstraints() {
    activeViewConstraintsPresetNotifier.value = null;
  }

  // ignore:use_setters_to_change_properties
  void setInitialViewConstraints(ViewConstraints viewConstraints) {
    _initialViewConstraints = viewConstraints;
  }

  void addViewConstraintsPreset(ViewConstraintsPreset preset) {
    final name = preset.name;
    assert(
      !_viewConstraintsPresetsByName.containsKey(name),
      'View constraints with name "$name" already exists',
    );
    _viewConstraintsPresetsByName[name] = preset;
  }

  void loadPreset(SelectableViewConstraintsPreset preset) {
    switch (preset) {
      case InitialViewConstraintsPreset():
        viewConstraintsNotifier.value = _initialViewConstraints;
        activeViewConstraintsPresetNotifier.value = preset;
      case DefinedViewConstraintsPreset(name: final presetId):
        final viewConstraints =
            _viewConstraintsPresetsByName[presetId]?.viewConstraints;
        if (viewConstraints != null) {
          viewConstraintsNotifier.value = viewConstraints;
          activeViewConstraintsPresetNotifier.value = preset;
        }
    }
  }

  @override
  void loadSnapshot(ConstraintsSnapshot snapshot) {
    viewConstraintsNotifier.value = snapshot.viewConstraints;
    final selectablePreset = snapshot.activePreset;
    if (selectablePreset != null) {
      loadPreset(selectablePreset);
    }
    sizeNotifier.value = snapshot.size;
  }

  @override
  ConstraintsSnapshot saveSnapshot() {
    return ConstraintsSnapshot(
      viewConstraints: viewConstraintsNotifier.value,
      activePreset: activeViewConstraintsPresetNotifier.value,
      size: sizeNotifier.value,
    );
  }

  @override
  void dispose() {
    _viewConstraintsNotifier?.dispose();
    activeViewConstraintsPresetNotifier.dispose();
    sizeNotifier.dispose();
    super.dispose();
  }
}

class ConstraintsSnapshot extends TransientUseCaseStateSnapshot {
  const ConstraintsSnapshot({
    required this.viewConstraints,
    required this.activePreset,
    required this.size,
  });

  final ViewConstraints viewConstraints;
  final SelectableViewConstraintsPreset? activePreset;
  final Size? size;
}

class _ViewConstraintsNotifier extends ValueNotifier<ViewConstraints> {
  _ViewConstraintsNotifier({
    required ViewConstraints initialValue,
    required BoxConstraints supportedSizes,
  }) : _supportedSizes = supportedSizes,
       super(_fixViewConstraints(initialValue, supportedSizes));

  static ViewConstraints _fixViewConstraints(
    ViewConstraints viewConstraints,
    BoxConstraints supportedSizes,
  ) {
    return viewConstraints
        .normalizeWithMinPriority()
        .enforce(supportedSizes)
        .limitInfiniteMinByView();
  }

  final BoxConstraints _supportedSizes;

  @override
  set value(ViewConstraints newValue) {
    super.value = _fixViewConstraints(newValue, _supportedSizes);
  }
}
