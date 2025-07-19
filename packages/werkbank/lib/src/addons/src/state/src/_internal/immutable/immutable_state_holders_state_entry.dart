import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holder.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holders_snapshot.dart';
import 'package:werkbank/werkbank.dart';

class ImmutableStateHoldersStateEntry
    extends
        TransientUseCaseStateEntry<
          ImmutableStateHoldersStateEntry,
          ImmutableStateHoldersSnapshot
        > {
  final Map<ImmutableStateHolderId, ImmutableStateHolder<Object?>>
  _stateHoldersById = {};

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    for (final holder in _stateHoldersById.values) {
      holder.prepareForBuild();
    }
  }

  @override
  Listenable? createRebuildListenable() {
    return Listenable.merge([
      for (final holder in _stateHoldersById.values) holder,
    ]);
  }

  void addStateHolder(
    ImmutableStateHolderId id,
    ImmutableStateHolder<Object?> stateHolder,
  ) {
    assert(
      !_stateHoldersById.containsKey(id),
      'StateHolder with id "$id" already exists',
    );
    _stateHoldersById[id] = stateHolder;
  }

  List<ImmutableStateHolder<Object?>> get stateHolders =>
      UnmodifiableListView(_stateHoldersById.values);

  @override
  void loadSnapshot(ImmutableStateHoldersSnapshot snapshot) {
    for (final MapEntry(key: id, value: stateHolder)
        in _stateHoldersById.entries) {
      if (snapshot.immutableStateHolderSnapshots.containsKey(id)) {
        final holderSnapshot = snapshot.immutableStateHolderSnapshots[id];
        if (holderSnapshot != null) {
          stateHolder.tryLoadSnapshot(holderSnapshot);
        }
      }
    }
  }

  @override
  ImmutableStateHoldersSnapshot saveSnapshot() {
    return ImmutableStateHoldersSnapshot(
      immutableStateHolderSnapshots: {
        for (final MapEntry(:key, :value) in _stateHoldersById.entries)
          key: value.createSnapshot(),
      }.lockUnsafe,
    );
  }

  @override
  void dispose() {
    for (final holder in _stateHoldersById.values) {
      holder.dispose();
    }
    super.dispose();
  }
}

class ImmutableStateHoldersSnapshot extends TransientUseCaseStateSnapshot {
  const ImmutableStateHoldersSnapshot({
    required this.immutableStateHolderSnapshots,
  });

  final IMap<ImmutableStateHolderId, ImmutableStateHolderSnapshot>
  immutableStateHolderSnapshots;
}
