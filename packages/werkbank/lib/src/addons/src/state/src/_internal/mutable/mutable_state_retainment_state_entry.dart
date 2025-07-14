import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_container.dart';
import 'package:werkbank/src/use_case/src/retained_use_case_state.dart';

class MutableStateRetainmentStateEntry
    extends RetainedUseCaseStateEntry<MutableStateRetainmentStateEntry> {
  final Map<MutableStateContainerId, _DisposableMutableValue<Object>>
  _disposableValuesById = {};

  void addMutableStateContainer<T extends Object>(
    MutableStateContainerId label,
    T value,
    void Function(T value) dispose,
  ) {
    final previousValue = _disposableValuesById[label];
    if (previousValue != null) {
      previousValue.dispose();
    }
    _disposableValuesById[label] = _DisposableMutableValue<T>(
      value: value,
      dispose: dispose,
    );
  }

  T? getMutableValue<T extends Object>(
    MutableStateContainerId label,
  ) {
    final container = _disposableValuesById[label];
    if (container == null) {
      throw StateError(
        'No mutable value found for label "$label". '
        'Have you added the mutable value to the state entry?',
      );
    }
    return container.value as T;
  }

  @override
  void dispose() {
    for (final container in _disposableValuesById.values) {
      container.dispose();
    }
    super.dispose();
  }
}

class _DisposableMutableValue<T extends Object> {
  _DisposableMutableValue({
    required this.value,
    required void Function(T value) dispose,
  }) : _dispose = dispose;

  final T value;
  final void Function(T value) _dispose;

  void dispose() {
    _dispose(value);
  }
}
