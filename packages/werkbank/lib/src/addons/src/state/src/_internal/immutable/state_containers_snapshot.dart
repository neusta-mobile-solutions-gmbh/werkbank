import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/state_container.dart';
import 'package:werkbank/werkbank.dart';

class StateContainersSnapshot extends TransientUseCaseStateSnapshot {
  const StateContainersSnapshot({
    required this.stateContainerSnapshots,
  });

  final IMap<StateContainerId, StateContainerSnapshot> stateContainerSnapshots;
}

@immutable
class StateContainerSnapshot {
  const StateContainerSnapshot({
    required this.value,
  });

  final Object? value;
}
