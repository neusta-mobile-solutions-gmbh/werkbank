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
      container.prepareForBuild();
    }
  }

  @override
  Listenable? createRebuildListenable() {
    return Listenable.merge([
      for (final container in _stateContainersById.values) container,
    ]);
  }

  void addStateContainer(
    StateContainerId id,
    StateContainer<Object?> stateContainer,
  ) {
    assert(
      !_stateContainersById.containsKey(id),
      'StateContainer with id "$id" already exists',
    );
    _stateContainersById[id] = stateContainer;
  }

  List<StateContainer<Object?>> get stateContainers =>
      UnmodifiableListView(_stateContainersById.values);

  @override
  void loadSnapshot(StateContainersSnapshot snapshot) {
    for (final MapEntry(key: id, value: stateContainer)
        in _stateContainersById.entries) {
      if (snapshot.stateContainerSnapshots.containsKey(id)) {
        final containerSnapshot = snapshot.stateContainerSnapshots[id];
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
