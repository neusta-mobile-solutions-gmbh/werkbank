import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_container.dart';
import 'package:werkbank/werkbank.dart';

class ImmutableStateContainersSnapshot extends TransientUseCaseStateSnapshot {
  const ImmutableStateContainersSnapshot({
    required this.immutableStateContainerSnapshots,
  });

  final IMap<ImmutableStateContainerId, ImmutableStateContainerSnapshot>
  immutableStateContainerSnapshots;
}

@immutable
class ImmutableStateContainerSnapshot {
  const ImmutableStateContainerSnapshot({
    required this.value,
  });

  final Object? value;
}
