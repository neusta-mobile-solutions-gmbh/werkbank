import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_holder.dart';
import 'package:werkbank/src/use_case/src/retained_use_case_state.dart';

class MutableStateRetainmentStateEntry
    extends RetainedUseCaseStateEntry<MutableStateRetainmentStateEntry> {
  final Map<MutableStateHolderId, _DisposableMutableValue>
  _disposableValuesById = {};

  void clean(bool Function(MutableStateHolderId id) shouldRemove) {
    _disposableValuesById.removeWhere((id, holder) {
      if (shouldRemove(id)) {
        holder.dispose();
        return true;
      }
      return false;
    });
  }

  void setMutableValue(
    MutableStateHolderId id,
    Object value,
    void Function(Object value) dispose,
  ) {
    final previousValue = _disposableValuesById[id];
    if (previousValue != null) {
      previousValue.dispose();
    }
    _disposableValuesById[id] = _DisposableMutableValue(
      value: value,
      dispose: dispose,
    );
  }

  Object? getMutableValue(
    MutableStateHolderId id,
  ) {
    final disposableValue = _disposableValuesById[id];
    if (disposableValue == null) {
      return null;
    }
    return disposableValue.value;
  }

  @override
  void dispose() {
    for (final holder in _disposableValuesById.values) {
      holder.dispose();
    }
    super.dispose();
  }
}

class _DisposableMutableValue {
  _DisposableMutableValue({
    required this.value,
    required void Function(Object value) dispose,
  }) : _dispose = dispose;

  final Object value;
  final void Function(Object value) _dispose;

  void dispose() {
    _dispose(value);
  }
}
