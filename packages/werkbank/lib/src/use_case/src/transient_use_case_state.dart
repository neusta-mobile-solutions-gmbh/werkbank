import 'package:flutter/cupertino.dart';
import 'package:werkbank/werkbank.dart';

/// A typedef for any [TransientUseCaseStateEntry] regardless of its generic
/// types.
typedef AnyTransientUseCaseStateEntry =
    _Self<TransientUseCaseStateEntry<Object?, TransientUseCaseStateSnapshot>>;

// This is a workaround for a dart bug.
// For some reason the type cannot be declared directly as a typedef.
typedef _Self<T> = T;

/// A class that contains state for the use case that is not retained
/// between hot reloads.
///
/// [Addon]s can override their [Addon.createTransientUseCaseStateEntries]
/// method to attach [TransientUseCaseStateEntry]s to the
/// [UseCaseComposer], which can then be used by the addon to store
/// state for the use case.
/// Once the use case is completely composed, the [TransientUseCaseStateEntry]s
/// will be transferred to the [UseCaseComposition].
///
/// During composition the [TransientUseCaseStateEntry]s can be accessed using
/// [UseCaseComposer.getTransientStateEntry].
/// After the composition is finished, they can be accessed via
/// [UseCaseComposition.getTransientStateEntry].
/// Both methods identify their entries by their generic type [T].
/// Therefore implementers should usually the type of the implementing class
/// as the generic type [T].
///
/// Every time the use case is recomposed, for example due to a hot reload,
/// a new [UseCaseComposer] with a new set of
/// [TransientUseCaseStateEntry]s is created.
/// In order to retain the state stored in the
/// [TransientUseCaseStateEntry]s across hot reloads, [saveSnapshot] is called
/// on each of the old and soon to be disposed [TransientUseCaseStateEntry]s.
/// The returned snapshot is passed to [loadSnapshot] on the new
/// [TransientUseCaseStateEntry]s after [prepareForBuild] is called.
/// The type of the snapshot is defined by the generic type [S].
///
/// This mechanism allows [TransientUseCaseStateEntry]s to store state which is
/// dependent on the composition of the use case.
/// For example, this is the case with knobs from the [KnobsAddon].
///
/// See also [RetainedUseCaseStateEntry] for state that is retained
/// between recompositions of the use case.
abstract class TransientUseCaseStateEntry<
  T extends TransientUseCaseStateEntry<T, S>,
  S extends TransientUseCaseStateSnapshot
> {
  /// Gets the generic type [T] which is used to identify this
  /// [TransientUseCaseStateEntry] when getting it via
  /// [UseCaseComposer.getTransientStateEntry] or
  /// [UseCaseComposition.getTransientStateEntry].
  Type get type => T;

  late bool _active;

  /// Whether this [TransientUseCaseStateEntry] is active or not.
  /// It becomes inactive when disposed.
  bool get active => _active;

  /// Initializes the state entry.
  @mustCallSuper
  void initState(UseCaseComposer composer) {
    _active = true;
  }

  /// This method is called before the use case is built in the widget tree.
  /// It can be used to do some final setup that is only necessary
  /// when this [TransientUseCaseStateEntry] is being used within widgets such
  /// as the [AddonControlSection]s defined by [Addon]s or the use case itself.
  ///
  /// It is possible that this instance is disposed before this method is
  /// ever called, for example when only the metadata is collected from the use
  /// case using [UseCaseDescriptor.computeMetadata].
  ///
  /// The [composition] can be used to interact with other
  /// [TransientUseCaseStateEntry]s or [RetainedUseCaseStateEntry]s.
  /// Keep in mind that the [prepareForBuild] method on other
  /// [TransientUseCaseStateEntry]s may not have been called yet.
  ///
  /// {@template werkbank.state_entry_build_context}
  /// The passed [BuildContext] is guaranteed to be a descendant of the
  /// layers in the [AddonLayer.management] layer.
  /// If a dependency for example to an [InheritedWidget] is make on the
  /// [context], a change to that dependency will cause the use case to
  /// recompose.
  /// {@endtemplate}
  @mustCallSuper
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {}

  /// Saves a snapshot of the current state. The returned snapshot can be used
  /// to restore the state after the use case recomposes, for example
  /// after a hot reload.
  ///
  /// [TransientUseCaseStateEntry]s that don't have anything to save can simply
  /// return a [TransientUseCaseStateSnapshot.new] instance
  /// and do nothing within [loadSnapshot].
  S saveSnapshot();

  /// Attempts to load a snapshot of the state as far as possible.
  ///
  /// The methods must be able to handle any snapshot that could be produced by
  /// [saveSnapshot] no matter what the current state is or what the
  /// state of the [TransientUseCaseStateEntry] at the time of saving was.
  void loadSnapshot(S snapshot);

  /// Creates a [Listenable] that causes a rebuild of the use case.
  /// If `null` is returned, the use case will not rebuild because of any
  /// changes in this state entry.
  ///
  /// This method is called once shortly after [prepareForBuild] has been called
  /// on all [TransientUseCaseStateEntry]s.
  Listenable? createRebuildListenable() => null;

  /// Disposes the state entry.
  @mustCallSuper
  void dispose() {
    _active = false;
  }
}

@immutable
class TransientUseCaseStateSnapshot {
  const TransientUseCaseStateSnapshot();
}
