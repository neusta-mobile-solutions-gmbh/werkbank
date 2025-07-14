import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_containers_snapshot.dart';

class BuildableStateContainer<T> implements StateContainer<T> {
  BuildableStateContainer({
    required this.label,
    required T initialValue,
  }) : notifier = ValueNotifier<T>(initialValue);

  @override
  final String label;

  @override
  late final ValueNotifier<T> notifier;

  void prepareForBuild(BuildContext context) {}

  StateContainerSnapshot createSnapshot() {
    return StateContainerSnapshot(value: notifier.value);
  }

  void tryLoadSnapshot(StateContainerSnapshot snapshot) {
    final snapshotValue = snapshot.value;
    if (snapshotValue is T) {
      notifier.value = snapshotValue;
    }
  }

  void dispose() {
    notifier.dispose();
  }
}

// TODO(lwiedekamp): Do we need something like ValueGuardingKnobMixin,
// ValueGuardingWritableKnobMixin or BuildableWritableKnob?
