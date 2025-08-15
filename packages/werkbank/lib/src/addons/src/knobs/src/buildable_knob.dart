import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/knobs_state_entry.dart';

/// A knob that can build a widget to control its value.
///
/// Instances of [BuildableKnob] can be registered using
/// [KnobsComposer.registerKnob].
///
/// When implementing a custom [BuildableKnob] consider using the mixins
/// [ValueGuardingKnobMixin] and [ValueGuardingWritableKnobMixin] to ensure
/// that the value of the knob is only accessed or modified after the
/// use case has finished composing.
abstract class BuildableKnob<T> implements Knob<T> {
  BuildableKnob({
    required this.label,
  });

  @override
  final String label;

  /// This method is called once [prepareForBuild] is called on the
  /// [KnobsStateEntry] to which this knob is registered.
  /// Since it is only valid to get or set the value of a knob after the
  /// use case has finished composing, this method can be used to initialize
  /// the value of the knob in case it needs access to a [BuildContext].
  @mustCallSuper
  void prepareForBuild(BuildContext context) {}

  /// Saves a snapshot of the current state of the knob.
  ///
  /// This snapshot is used to restore the state of the knob
  /// with [tryLoadSnapshot], for example after a hot reload.
  KnobSnapshot createSnapshot();

  /// Restores the state of the knob from a snapshot.
  ///
  /// Implementers should not make any assumptions about the subtype of the
  /// snapshot.
  /// For example it could be the case that after a hot reload, the
  /// generic type of the knob has changed, or the knob may even be
  /// of a completely different type, which means the snapshot is loaded on a
  /// different subclass of [BuildableKnob].
  /// If it is not possible to load the snapshot, for example because its saved
  /// value is incompatible with this knob or because the passed [snapshot] is
  /// of an unknown type, this method should do nothing.
  void tryLoadSnapshot(KnobSnapshot snapshot);

  /// Resets the knob to its initial state.
  void resetToInitial();

  /// Returns a listenable that notifies when the content of the knob changes.
  ///
  /// This may either be, when the [value] changes, or in case the [value] is
  /// mutable if the state of the [value] changes.
  Listenable get contentChangedListenable;

  /// Builds the widget used to control the knob.
  Widget build(BuildContext context);

  @override
  T get value;

  @mustCallSuper
  void dispose() {
    // We shouldn't ever put anything here, since if classes such as
    // [BuildableWritableKnob] mix in [ChangeNotifier], they will create their
    // own dispose method which overrides this one without ever calling this
    // one as `super.dispose()`.
  }
}

/// A mixin that guards the value of a knob to only be accessed after the
/// use case has finished composing.
mixin ValueGuardingKnobMixin<T> on BuildableKnob<T> {
  bool _isAfterBuild = false;

  @override
  void prepareForBuild(BuildContext context) {
    super.prepareForBuild(context);
    _isAfterBuild = true;
  }

  @override
  T get value {
    if (!_isAfterBuild) {
      throw StateError(
        'The value of a knob can only be read after the the use case has '
        'finished composing. '
        'Have you accidentally used a knob value directly in the builder '
        'of a use case instead of its returned WidgetBuilder '
        'or a knob preset?',
      );
    }
    return super.value;
  }
}

/// A mixin that guards the value of a writable knob to only be set after the
/// use case has finished composing.
///
/// This mixin should be used in combination with [ValueGuardingKnobMixin].
mixin ValueGuardingWritableKnobMixin<T>
    on WritableKnob<T>, ValueGuardingKnobMixin<T> {
  @override
  set value(T newValue) {
    if (!_isAfterBuild) {
      throw StateError(
        'The value of a knob can only be set after the the use case has '
        'finished composing. '
        'Have you accidentally set a knob value directly in the builder '
        'of a use case instead of its returned WidgetBuilder '
        'or a knob preset?',
      );
    }
    super.value = newValue;
  }
}

/// A base implementation of [BuildableKnob] that implements [WritableKnob]
/// and manages the [value] of the knob.
///
/// When extending this class, consider mixin in [ValueGuardingKnobMixin] and
/// [ValueGuardingWritableKnobMixin].
abstract class BuildableWritableKnob<T> extends BuildableKnob<T>
    with ChangeNotifier
    implements WritableKnob<T> {
  BuildableWritableKnob({
    required super.label,
    required T initialValue,
  }) : _value = initialValue {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  @override
  T get value => _value;
  T _value;

  @override
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  Listenable get contentChangedListenable => this;
}
