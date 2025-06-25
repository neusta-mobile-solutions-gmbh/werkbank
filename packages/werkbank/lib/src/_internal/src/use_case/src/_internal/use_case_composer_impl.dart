import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:werkbank/src/_internal/src/use_case/src/_internal/use_case_composition_impl.dart';
import 'package:werkbank/src/_internal/src/use_case/src/use_case_controller.dart';
import 'package:werkbank/werkbank.dart';

class UseCaseComposerImpl implements UseCaseComposer {
  UseCaseComposerImpl({
    required WerkbankUseCase useCase,
    required List<AnyTransientUseCaseStateEntry> transientStateEntries,
    required Set<String> activeAddons,
  }) : _activeAddons = activeAddons,
       _useCase = useCase {
    final transientStateEntriesMap = <Type, AnyTransientUseCaseStateEntry>{};
    for (final entry in transientStateEntries) {
      final type = entry.type;
      assert(
        !transientStateEntriesMap.containsKey(type),
        'Transient state entry of type $type already exists',
      );
      entry.initState(this);
      transientStateEntriesMap[type] = entry;
    }
    _transientState = transientStateEntriesMap.lock;
  }

  late WerkbankNode _node;

  final WerkbankUseCase _useCase;

  final Map<Type, UseCaseMetadataEntry> _metadata = {};

  late final IMap<Type, AnyTransientUseCaseStateEntry> _transientState;

  final List<VoidCallback> _lateExecutionCallbacks = [];

  final Set<String> _activeAddons;

  bool _active = true;

  @override
  bool get active => _active;

  @override
  WerkbankNode get node {
    _ensureNotDisposed();
    return _node;
  }

  @override
  WerkbankUseCase get useCase {
    _ensureNotDisposed();
    return _useCase;
  }

  void setNode(WerkbankNode node) {
    _ensureNotDisposed();
    _node = node;
  }

  @override
  void addLateExecutionCallback(VoidCallback callback) {
    _ensureNotDisposed();
    _lateExecutionCallbacks.add(callback);
  }

  void runLateExecutionCallbacks() {
    _ensureNotDisposed();
    // We can't use a for(final callback in _lateExecutionCallbacks) loop here
    // because the callbacks might add more callbacks to the list.
    for (var i = 0; i < _lateExecutionCallbacks.length; i++) {
      _lateExecutionCallbacks[i]();
    }
  }

  @override
  T? getMetadata<T extends UseCaseMetadataEntry<T>>() {
    _ensureNotDisposed();
    return _metadata[T] as T?;
  }

  @override
  void setMetadata<T extends UseCaseMetadataEntry<T>>(T metadata) {
    _ensureNotDisposed();
    final metadataType = metadata.type;
    _metadata[metadataType] = metadata;
  }

  @override
  T getTransientStateEntry<
    T extends TransientUseCaseStateEntry<T, TransientUseCaseStateSnapshot>
  >() {
    _ensureNotDisposed();
    final state = _transientState[T];
    assert(
      state != null,
      'Transient state entry of type $T does not exist. '
      'Have you forgotten to add the addon, which sets up the state? '
      'Or if you are developing an addon, ensure that you have added the '
      'state entry in [Addon.createTransientUseCaseStateEntries]',
    );
    return state! as T;
  }

  UseCaseMetadata _getMetadata() => UseCaseMetadata.fromMap(_metadata);

  void _ensureNotDisposed() {
    if (!_active) {
      throw StateError(
        'This UseCaseComposer has been disposed and '
        'can no longer be used. '
        'Have you accidentally called a method on the UseCaseComposer "c" '
        'inside of the WidgetBuilder returned by the UseCaseBuilder instead '
        'of in the UseCaseBuilder directly?',
      );
    }
  }

  @override
  bool isAddonActive(String addonId) {
    _ensureNotDisposed();
    return _activeAddons.contains(addonId);
  }

  void _dispose() {
    _active = false;
  }

  void _disposeTransientStateEntries() {
    for (final state in _transientState.values) {
      state.dispose();
    }
  }

  void abortAndDispose() {
    _ensureNotDisposed();
    _disposeTransientStateEntries();
    _dispose();
  }

  UseCaseMetadata getMetadataAndDispose() {
    _ensureNotDisposed();
    final metadata = _getMetadata();
    _disposeTransientStateEntries();
    _dispose();
    return metadata;
  }

  UseCaseCompositionImpl composeAndDispose(UseCaseController controller) {
    _ensureNotDisposed();
    final metadata = _getMetadata();
    final transientStateEntries = _transientState;
    _dispose();
    return UseCaseCompositionImpl(
      controller: controller,
      metadata: metadata,
      transientStateEntries: transientStateEntries,
    );
  }
}
