import 'package:flutter/material.dart' hide Element;
import 'package:werkbank/src/addons/src/knobs/src/_internal/knobs_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/element_snapshot.dart';
import 'package:werkbank/werkbank.dart';

abstract class BuildableElement<T> implements Element<T> {
  BuildableElement({
    required this.label,
  });

  @override
  final String label;

  @mustCallSuper
  void prepareForBuild(BuildContext context) {}

  ElementSnapshot createSnapshot();

  void tryLoadSnapshot(ElementSnapshot snapshot);

  Listenable get contentChangedListenable;

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
// mixin ValueGuardingKnobMixin<T> on BuildableElement<T> {
//   bool _isAfterBuild = false;

//   @override
//   void prepareForBuild(BuildContext context) {
//     super.prepareForBuild(context);
//     _isAfterBuild = true;
//   }

//   @override
//   T get value {
//     if (!_isAfterBuild) {
//       throw StateError(
//         'The value of a knob can only be read after the the use case has '
//         'finished composing. '
//         'Have you accidentally used a knob value directly in the builder '
//         'of a use case instead of its returned WidgetBuilder '
//         'or a knob preset?',
//       );
//     }
//     return super.value;
//   }
// }

/// A mixin that guards the value of a writable knob to only be set after the
/// use case has finished composing.
///
/// This mixin should be used in combination with [ValueGuardingKnobMixin].
// mixin ValueGuardingWritableKnobMixin<T>
//     on WritableKnob<T>, ValueGuardingKnobMixin<T> {
//   @override
//   set value(T newValue) {
//     if (!_isAfterBuild) {
//       throw StateError(
//         'The value of a knob can only be set after the the use case has '
//         'finished composing. '
//         'Have you accidentally set a knob value directly in the builder '
//         'of a use case instead of its returned WidgetBuilder '
//         'or a knob preset?',
//       );
//     }
//     super.value = newValue;
//   }
// }

/// A base implementation of [BuildableElement] that implements [WritableKnob]
/// and manages the [value] of the knob.
///
/// When extending this class, consider mixin in [ValueGuardingKnobMixin] and
/// [ValueGuardingWritableKnobMixin].
// abstract class BuildableWritableKnob<T> extends BuildableElement<T>
//     with ChangeNotifier
//     implements WritableKnob<T> {
//   BuildableWritableKnob({
//     required super.label,
//     required T initialValue,
//   }) : _value = initialValue {
//     if (kFlutterMemoryAllocationsEnabled) {
//       ChangeNotifier.maybeDispatchObjectCreation(this);
//     }
//   }

//   @override
//   T get value => _value;
//   T _value;

//   @override
//   set value(T newValue) {
//     if (_value == newValue) {
//       return;
//     }
//     _value = newValue;
//     notifyListeners();
//   }

//   @override
//   Listenable get contentChangedListenable => this;
// }
