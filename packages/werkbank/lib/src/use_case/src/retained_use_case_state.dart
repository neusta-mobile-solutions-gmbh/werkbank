import 'package:flutter/material.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// A typedef for any [RetainedUseCaseStateEntry] regardless of its generic
/// type.
typedef AnyRetainedUseCaseStateEntry =
    _Self<RetainedUseCaseStateEntry<Object?>>;

// This is a workaround for a dart bug.
// For some reason the type cannot be declared directly as a typedef.
typedef _Self<T> = T;

/* TODO(lzuttermeister): Do we need a method to interact with other
     RetainedUseCaseStateEntries? */

/// A state entry keeps state for a use case for its whole lifetime.
/// Unlike [TransientUseCaseStateEntry]s, [RetainedUseCaseStateEntry]s are
/// not recreated when the use case is recomposed,
/// for example due to a hot reload.
///
/// [RetainedUseCaseStateEntry]s can be accessed via
/// [UseCaseComposition.getRetainedStateEntry].
/// This method identifies its entries by their generic type [T].
/// Therefore implementers should usually the type of the implementing class
/// as the generic type [T].
///
/// To interact with [TransientUseCaseStateEntry]s, you can implement the
/// [TransientUseCaseStateEntry.prepareForBuild] method and use the
/// passed [UseCaseComposition] to access the [RetainedUseCaseStateEntry]s.
class RetainedUseCaseStateEntry<T extends RetainedUseCaseStateEntry<T>> {
  /// Gets the generic type [T] which is used to identify this
  /// [RetainedUseCaseStateEntry] when getting it via
  /// [UseCaseComposition.getRetainedStateEntry].
  Type get type => T;

  bool _active = true;

  /// Whether this [RetainedUseCaseStateEntry] is active or not.
  /// It becomes inactive when disposed.
  bool get active => _active;

  /// Initializes the state entry.
  ///
  /// {@macro werkbank.state_entry_build_context}
  @mustCallSuper
  void initState(BuildContext context) {}

  /// Disposes the state entry.
  @mustCallSuper
  void dispose() {
    _active = false;
  }
}
