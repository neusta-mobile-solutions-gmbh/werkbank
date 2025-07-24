import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/immutable/immutable_state_holders_snapshot.dart';

class ImmutableStateHolder<T> extends ValueNotifier<T> {
  ImmutableStateHolder({
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
        'The value of a state holder can only be set after the use case has '
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
        'The value of a state holder can only '
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

  ImmutableStateHolderSnapshot createSnapshot() {
    return ImmutableStateHolderSnapshot(value: value);
  }

  void tryLoadSnapshot(ImmutableStateHolderSnapshot snapshot) {
    final snapshotValue = snapshot.value;
    if (snapshotValue is T) {
      value = snapshotValue;
    }
  }
}
