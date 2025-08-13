import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/use_case/src/_internal/use_case_composer_lifecycle_manager.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

// TODO(lzuttermeister): Do not expose publicly.
class UseCaseController extends ChangeNotifier {
  UseCaseController();

  CompositionResult? _currentCompositionResult;

  bool get isAssembled => _currentCompositionResult != null;

  UseCaseComposition? get currentComposition =>
      _currentCompositionResult?.composition;

  IMap<Type, AnyRetainedUseCaseStateEntry>? _retainedState;
  ISet<String>? _previousAssemblyAddons;

  void assemble(
    UseCaseDescriptor useCaseDescriptor, {
    required BuildContext context,
    UseCaseStateMutation? initialMutation,
    bool keepState = true,
  }) {
    final addonConfig = AddonConfigProvider.of(context);
    final addons = addonConfig.addons;
    final currentAddons = addons.map((a) => a.id).toISet();
    // If addons change, the needed retained state entries may have changed.
    // Therefore, we need to reset the state and regenerate the
    // retained state entries.
    final effectiveKeepState =
        keepState && currentAddons == _previousAssemblyAddons;
    _previousAssemblyAddons = currentAddons;
    final stateSnapshot = effectiveKeepState
        ? currentComposition?.saveSnapshot()
        : null;
    _currentCompositionResult?.composition.dispose();
    /* TODO(lzuttermeister): What if something fails below?
         Should we set this later? */
    final manager = UseCaseComposerLifecycleManager.initialize(
      useCaseDescriptor,
      addonConfig: addonConfig,
    );
    if (_retainedState == null || !effectiveKeepState) {
      _retainedState?.values.forEach((entry) => entry.dispose());
      final retainedStateEntries = [
        for (final addon in addons)
          ...addon.createRetainedUseCaseStateEntries(),
      ];
      final retainedState = <Type, AnyRetainedUseCaseStateEntry>{};
      for (final entry in retainedStateEntries) {
        final type = entry.type;
        assert(
          !retainedState.containsKey(type),
          'Retained state entry of type $type already exists',
        );
        entry.initState(context);
        retainedState[type] = entry;
      }
      _retainedState = retainedState.lockUnsafe;
    }

    _currentCompositionResult = manager.convertToCompositionAndDispose(
      context: context,
      useCaseSnapshot: stateSnapshot,
      initialMutation: initialMutation,
      controller: this,
    );
    notifyListeners();
  }

  Widget useCaseWidget({
    required Widget Function(BuildContext, Object, StackTrace stackTrace)
    errorBuilder,
  }) {
    if (!isAssembled) {
      throw StateError('The UseCaseController has not been assembled yet.');
    }
    return ListenableBuilder(
      listenable: _currentCompositionResult!.composition.rebuildListenable,
      builder: (context, _) {
        switch (_currentCompositionResult!.buildResult) {
          case final UseCaseSuccessfulBuild successfulBuild:
            return successfulBuild.widgetBuilder(context);
          case final UseCaseFailedBuild failedBuild:
            return errorBuilder(
              context,
              failedBuild.error,
              failedBuild.stackTrace,
            );
        }
      },
    );
  }

  /// Gets the [RetainedUseCaseStateEntry] of the given type.
  T getRetainedStateEntry<T extends AnyRetainedUseCaseStateEntry>() {
    final state = _retainedState![T];
    assert(
      state != null,
      'Retained state entry of type $T does not exist. '
      'Have you forgotten to add the addon, which sets up the state? '
      'Or if you are developing an addon, ensure that you have added the '
      'state entry in [Addon.createRetainedUseCaseStateEntries]. '
      'Once you have done that a hot restart may be necessary.',
    );
    return state! as T;
  }

  @override
  void dispose() {
    _currentCompositionResult?.composition.dispose();
    _retainedState?.values.forEach((entry) => entry.dispose());
    super.dispose();
  }
}
