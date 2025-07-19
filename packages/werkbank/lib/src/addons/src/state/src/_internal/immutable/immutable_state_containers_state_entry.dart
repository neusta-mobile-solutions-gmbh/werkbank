import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_container.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_containers_snapshot.dart';
import 'package:werkbank/werkbank.dart';

class ImmutableStateContainersStateEntry
    extends
        TransientUseCaseStateEntry<
          ImmutableStateContainersStateEntry,
          ImmutableStateContainersSnapshot
        > {
  final Map<ImmutableStateContainerId, ImmutableStateContainer<Object?>>
  _stateContainersById = {};

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
    ImmutableStateContainerId id,
    ImmutableStateContainer<Object?> stateContainer,
  ) {
    assert(
      !_stateContainersById.containsKey(id),
      'StateContainer with id "$id" already exists',
    );
    _stateContainersById[id] = stateContainer;
  }

  List<ImmutableStateContainer<Object?>> get stateContainers =>
      UnmodifiableListView(_stateContainersById.values);

  @override
  void loadSnapshot(ImmutableStateContainersSnapshot snapshot) {
    for (final MapEntry(key: id, value: stateContainer)
        in _stateContainersById.entries) {
      if (snapshot.immutableStateContainerSnapshots.containsKey(id)) {
        final containerSnapshot = snapshot.immutableStateContainerSnapshots[id];
        if (containerSnapshot != null) {
          stateContainer.tryLoadSnapshot(containerSnapshot);
        }
      }
    }
  }

  @override
  ImmutableStateContainersSnapshot saveSnapshot() {
    return ImmutableStateContainersSnapshot(
      immutableStateContainerSnapshots: {
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

class ImmutableStateContainersSnapshot extends TransientUseCaseStateSnapshot {
  const ImmutableStateContainersSnapshot({
    required this.immutableStateContainerSnapshots,
  });

  final IMap<ImmutableStateContainerId, ImmutableStateContainerSnapshot>
  immutableStateContainerSnapshots;
}
