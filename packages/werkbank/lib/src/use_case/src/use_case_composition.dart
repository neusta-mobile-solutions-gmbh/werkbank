import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

/// A function that mutates the state of a use case using the provided
/// [UseCaseComposition].
typedef UseCaseStateMutation =
    void Function(
      UseCaseComposition controller,
    );

/// A class that holds the result of composing a use cases using a
/// [UseCaseComposer].
/// An instance can be use to control the state of the use case as well as get
/// the metadata of the use case.
///
/// The [UseCaseComposition] can be accessed in a use case via
/// [UseCase.compositionOf].
/// Addons can use [UseCaseAccessorMixin.compositionOf] to access the
/// for some of the layers or panels.
/// Additionally [UseCaseDisplay].
///
/// Specifically, it holds the produced [UseCaseMetadata] as well as the
/// [TransientUseCaseStateEntry]s resulting from the composition.
/// Additionally, it gives access to the [RetainedUseCaseStateEntry]s, which are
/// technically not created during composition, but are nevertheless
/// necessary to controlling the use case state.
///
/// Addons should make extension on this type to provide the means of
/// controlling every state of the the use case which is also controllable
/// in the "USE CASE" panel of the [WerkbankApp].
///
/// {@category Display}
abstract interface class UseCaseComposition {
  /// The [UseCaseMetadata] of the use case.
  UseCaseMetadata get metadata;

  /// Gets the [TransientUseCaseStateEntry] that has the given
  /// generic type [T] as its [TransientUseCaseStateEntry.type].
  T getTransientStateEntry<
    T extends TransientUseCaseStateEntry<T, TransientUseCaseStateSnapshot>
  >();

  /// Gets the [RetainedUseCaseStateEntry] that has the given
  /// generic type [T] as its [RetainedUseCaseStateEntry.type].
  T getRetainedStateEntry<T extends RetainedUseCaseStateEntry<T>>();

  /// A [Listenable] that notifies whenever the [WidgetBuilder] from the
  /// use case should be rebuilt.
  ///
  /// This consists of a [Listenable.merge] that combines the [Listenable]s
  /// returned by calling [TransientUseCaseStateEntry.createRebuildListenable]
  /// on all [TransientUseCaseStateEntry]s.
  ///
  /// [Addon]s may also use this if they introduce widgets into the tree that
  /// are created inside of the [UseCaseBuilder].
  /// In that case, the widgets may use mutable data from the composition
  /// which should cause the use case to be rebuilt when it changes.
  /// An example of this are the knobs from the [KnobsAddon].
  Listenable get rebuildListenable;

  /// Saves the current state of the use case as a [UseCaseSnapshot].
  UseCaseSnapshot saveSnapshot();

  /// Restores the state of the use case using the provided
  /// [UseCaseSnapshot].
  void loadSnapshot(UseCaseSnapshot snapshot);

  /// Runs the provided [UseCaseStateMutation] using this [UseCaseComposition].
  void mutate(UseCaseStateMutation mutation);
}
