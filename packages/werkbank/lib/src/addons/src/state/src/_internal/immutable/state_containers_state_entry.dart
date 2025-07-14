import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/state_containers_snapshot.dart';
import 'package:werkbank/werkbank.dart';

class StateContainersStateEntry
    extends
        TransientUseCaseStateEntry<
          StateContainersStateEntry,
          StateContainersSnapshot
        > {
  final Map<StateContainerId, StateContainer<Object?>> _stateContainersById =
      {};

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    for (final container in _stateContainersById.values) {
      container.prepareForBuild(context);
    }
  }

  @override
  Listenable? createRebuildListenable() {
    return Listenable.merge([
      for (final container in _stateContainersById.values) container,
    ]);
  }

  void addStateContainer(
    StateContainerId label,
    StateContainer<Object?> stateContainer,
  ) {
    assert(
      !_stateContainersById.containsKey(label),
      'StateContainer with label "$label" already exists',
    );
    _stateContainersById[label] = stateContainer;
  }

  List<StateContainer<Object?>> get stateContainers =>
      UnmodifiableListView(_stateContainersById.values);

  @override
  void loadSnapshot(StateContainersSnapshot snapshot) {
    for (final entry in _stateContainersById.entries) {
      final label = entry.key;
      final stateContainer = entry.value;
      if (snapshot.stateContainerSnapshots.containsKey(label)) {
        final containerSnapshot = snapshot.stateContainerSnapshots[label];
        if (containerSnapshot != null) {
          stateContainer.tryLoadSnapshot(containerSnapshot);
        }
      }
    }
  }

  @override
  StateContainersSnapshot saveSnapshot() {
    return StateContainersSnapshot(
      stateContainerSnapshots: {
        for (final MapEntry(:key, :value) in _stateContainersById.entries)
          key: value.createSnapshot(),
      }.lockUnsafe,
    );
  }

  @override
  void dispose() {
    for (final container in _stateContainersById.values) {
      container.dispose();
    }
    super.dispose();
  }
}
