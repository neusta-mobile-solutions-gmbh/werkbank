import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/use_case/src/use_case_controller.dart';
import 'package:werkbank/src/use_case/use_case.dart';

class UseCaseCompositionImpl implements UseCaseComposition {
  UseCaseCompositionImpl({
    required UseCaseController controller,
    required this.metadata,
    required IMap<Type, AnyTransientUseCaseStateEntry> transientStateEntries,
  }) : _controller = controller,
       _transientState = transientStateEntries;

  final UseCaseController _controller;
  @override
  final UseCaseMetadata metadata;
  final IMap<Type, AnyTransientUseCaseStateEntry> _transientState;
  bool _isDisposed = false;

  Iterable<AnyTransientUseCaseStateEntry> get transientStateEntries =>
      _transientState.values;

  @override
  late final Listenable rebuildListenable;

  @override
  T getTransientStateEntry<
    T extends TransientUseCaseStateEntry<T, TransientUseCaseStateSnapshot>
  >() {
    // We allow this method even if disposed in order for users of the
    // state entries to get them on a disposed composition and do some final
    // cleanup such as removing listeners from from listenables stored in the
    // state entries.
    return _transientState[T]! as T;
  }

  @override
  T getRetainedStateEntry<T extends RetainedUseCaseStateEntry<T>>() {
    // We allow this method even if disposed in order for users of the
    // state entries to get them on a disposed composition and do some final
    // cleanup such as removing listeners from from listenables stored in the
    // state entries.
    return _controller.getRetainedStateEntry<T>();
  }

  @override
  UseCaseSnapshot saveSnapshot() {
    _ensureNotDisposed();
    return UseCaseSnapshot.fromMap(
      {
        for (final MapEntry(:key, :value) in _transientState.entries)
          key: value.saveSnapshot(),
      },
    );
  }

  @override
  void loadSnapshot(UseCaseSnapshot snapshot) {
    _ensureNotDisposed();
    for (final MapEntry(:key, :value) in snapshot.snapshots.entries) {
      final state = _transientState[key];
      if (state != null) {
        state.loadSnapshot(value);
      }
    }
  }

  @override
  void mutate(UseCaseStateMutation mutation) {
    _ensureNotDisposed();
    mutation(this);
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('Cannot use UseCaseComposition after it is disposed.');
    }
  }

  void dispose() {
    for (final state in _transientState.values) {
      state.dispose();
    }
    _isDisposed = true;
  }
}
