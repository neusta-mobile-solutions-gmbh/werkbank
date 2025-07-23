import 'dart:ui';

import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/src/transient_use_case_state.dart';
import 'package:werkbank/src/use_case/src/use_case_metadata.dart';

/// A class of which an instance is passed to a [UseCaseBuilder], allowing use
/// cases to do all kinds of useful things with it.
///
/// Most of the functionality of the [UseCaseComposer] is defined
/// in extension methods introduced by addons.
///
/// On a more technical level, this class
/// manages a single composition of a use case and
/// allows to influence the composition process.
///
/// The methods of this class can be used to add metadata to the use case,
/// manage the [TransientUseCaseStateEntry]s of the use case and more.
///
/// Each time a use case is composed, a new instance of this class
/// passed to the corresponding [UseCaseBuilder].
/// After the composition is done most of the information collected on the
/// [UseCaseComposer] is transferred to a [UseCaseComposition].
///
/// {@category Writing Use Cases}
/// {@category Custom Use Case Metadata}
abstract interface class UseCaseComposer {
  /// Whether the [UseCaseComposer] is active or not.
  ///
  /// The composer is active while the use case is being composed.
  ///
  /// Most method calls on this [UseCaseComposer]
  /// will throw after this [UseCaseComposer] is disposed
  /// and therefore no longer active.
  bool get active;

  /// The [WerkbankNode] for which its [UseCaseBuilder] or
  /// [UseCaseParentBuilder] is currently
  /// being executed using this [UseCaseComposer].
  WerkbankNode get node;

  /// The [WerkbankUseCase] which is currently being composed
  /// using this [UseCaseComposer].
  WerkbankUseCase get useCase;

  /// Schedules a callback to be executed shortly before the composition is
  /// done and therefore after the [WerkbankUseCase.builder]
  /// has been executed.
  ///
  /// The callbacks are executed in the order they were added.
  /// It is legal to call [addLateExecutionCallback] inside of a callback
  /// added by [addLateExecutionCallback] itself.
  void addLateExecutionCallback(VoidCallback callback);

  /// Gets the current [UseCaseMetadataEntry] that has the given
  /// generic type [T] as its [UseCaseMetadataEntry.type].
  ///
  /// Implementers of custom metadata should consider writing
  /// a more user friendly extension method
  /// on this class instead of expecting users to use this method directly.
  T? getMetadata<T extends UseCaseMetadataEntry<T>>();

  /// Sets a [UseCaseMetadataEntry].
  ///
  /// This overwrites any existing [UseCaseMetadataEntry] with the same
  /// [UseCaseMetadataEntry.type].
  ///
  /// Implementers of custom metadata should consider writing
  /// a more user friendly extension method
  /// on this class instead of expecting users to use this method directly.
  void setMetadata<T extends UseCaseMetadataEntry<T>>(T metadata);

  /// Gets the [TransientUseCaseStateEntry] that has the given
  /// generic type [T] as its [TransientUseCaseStateEntry.type].
  ///
  /// Since [TransientUseCaseStateEntry]s are introduces by [Addon]s,
  /// normal use case writers will rarely have to use this method directly.
  /// Addons should write more user friendly methods
  /// as extension methods on this class.
  T getTransientStateEntry<
    T extends TransientUseCaseStateEntry<T, TransientUseCaseStateSnapshot>
  >();

  /// Checks whether an addon with the given [addonId]
  /// is used in the current composition.
  ///
  /// You can use this method to write extensions on an [UseCaseComposer] and
  /// you optionally want to use some other methods on it
  /// that are only available when the addon introducing it is being used.
  bool isAddonActive(String addonId);
}
