import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/state_containers_snapshot.dart';

extension type StateContainerId(String _label) {}

class StateContainer<T> extends ValueNotifier<T> {
  StateContainer({
    required T initialValue,
  }) : super(initialValue);

  bool _isAfterBuild = false;

  void prepareForBuild() {
    _isAfterBuild = true;
  }

  @override
  set value(T newValue) {
    if (!_isAfterBuild) {
      throw StateError(
        'The value of a state container can only be set after the use case has '
        'finished composing. '
        'Have you accidentally set a state value directly in the '
        'UseCaseBuilder function instead of its returned WidgetBuilder? '
        'State changes should only occur in event handlers or in response '
        'to user interactions within the widget tree.',
      );
    }
    super.value = newValue;
  }

  @override
  T get value {
    if (!_isAfterBuild) {
      throw StateError(
        'The value of a state container can only '
        'be read after the use case has '
        'finished composing. '
        'Have you accidentally accessed a state value directly in the '
        'UseCaseBuilder function instead of its returned WidgetBuilder? '
        'State should only be accessed within the widget tree or in '
        'event handlers.',
      );
    }
    return super.value;
  }

  StateContainerSnapshot createSnapshot() {
    return StateContainerSnapshot(value: value);
  }

  void tryLoadSnapshot(StateContainerSnapshot snapshot) {
    final snapshotValue = snapshot.value;
    if (snapshotValue is T) {
      value = snapshotValue;
    }
  }
}
