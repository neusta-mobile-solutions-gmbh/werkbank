import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:werkbank/src/use_case/src/transient_use_case_state.dart';
import 'package:werkbank/src/use_case/src/use_case_composition.dart';

/// An immutable snapshot of the [TransientUseCaseStateEntry]s of a use case.
/// This can be obtained using [UseCaseComposition.saveSnapshot] and restored
/// using [UseCaseComposition.loadSnapshot].
@immutable
class UseCaseSnapshot {
  UseCaseSnapshot.fromMap(
    Map<Type, TransientUseCaseStateSnapshot> snapshots,
  ) : _snapshots = snapshots.lock;

  final IMap<Type, TransientUseCaseStateSnapshot> _snapshots;

  /// Gets a map from the [TransientUseCaseStateEntry.type] to the
  /// [TransientUseCaseStateSnapshot] that the corresponding
  /// [TransientUseCaseStateEntry] generated using
  /// [TransientUseCaseStateEntry.saveSnapshot].
  Map<Type, TransientUseCaseStateSnapshot> get snapshots =>
      _snapshots.unlockView;
}
