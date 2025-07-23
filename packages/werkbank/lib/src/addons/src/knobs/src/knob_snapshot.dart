import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

/// The base class for an immutable snapshot of the `value` of a [Knob].
/// Since knobs in a use case may completely change after a hot reload,
/// all [Knob]s are recreated on every execution of the [UseCaseBuilder].
/// To keep the state of a knob, their value is saved to a [KnobSnapshot]
/// with [BuildableKnob.createSnapshot] and an attempt is made to restore it
/// using [BuildableKnob.tryLoadSnapshot].
@immutable
abstract class KnobSnapshot {
  const KnobSnapshot();
}
