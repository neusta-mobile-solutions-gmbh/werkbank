import 'package:flutter/foundation.dart';
import 'package:werkbank/werkbank_old.dart';

/// A unique identifier for a knob.
extension type KnobId(String _label) {}

/// A knob to control a value in a use case.
///
/// All implementations of this interface should extend [BuildableKnob].
abstract interface class Knob<T> {
  /// The label of the knob.
  ///
  /// This is used as the display name of the knob in the UI.
  /// From this label, a unique [KnobExtension.id] is generated that is used to
  /// keep the state of the knob across hot reloads.
  String get label;

  /// Gets the value of the knob.
  ///
  /// {@template werkbank.only_call_after_composition}
  /// This should only be called when the use case has finished composing.
  /// {@endtemplate}
  T get value;
}

extension KnobExtension<T> on Knob<T> {
  /// A unique identifier for the knob generated from its [label].
  ///
  /// The [id] is used to keep the state of the knob across hot reloads.
  KnobId get id => KnobId(label);
}

abstract interface class WritableKnob<T> extends Knob<T>
    implements ValueNotifier<T> {
  /// Sets the value of the knob.
  ///
  /// {@macro werkbank.only_call_after_composition}
  @override
  set value(T value);
}
