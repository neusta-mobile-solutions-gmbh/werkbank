import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/components/components.dart';

typedef RegularKnobBuilder<T> =
    Widget Function(
      BuildContext context,
      ValueNotifier<T> valueNotifier,
    );

extension RegularKnobsExtension on KnobsComposer {
  /// Creates and registers a knob, which can be used to control a value in
  /// the use case.
  ///
  /// This should not be used directly.
  /// Instead there are extension methods for different types of knobs.
  ///
  /// ## Building a Knob
  /// By convention a knob extension method should have a single positional
  /// parameter `label`, which is passed to the [label] parameter of
  /// this method.
  /// Additionally the extension method should have named parameter
  /// `initialValue`, which is passed to the [initialValue] parameter.
  /// The [knobBuilder] is a function that builds the control widget for the
  /// knob.
  WritableKnob<T> makeRegularKnob<T>(
    String label, {
    required T initialValue,
    bool forceSpaciousLayout = false,
    required RegularKnobBuilder<T> knobBuilder,
    bool rebuildKnobBuilderOnChange = true,
    Widget? trailingIconButton,
  }) {
    final knob = RegularKnob<T>(
      label: label,
      initialValue: initialValue,
      knobBuilder: knobBuilder,
      rebuildKnobBuilderOnChange: rebuildKnobBuilderOnChange,
      forceSpaciousLayout: forceSpaciousLayout,
      trailingIconButton: trailingIconButton,
    );
    registerKnob(knob);
    return knob;
  }
}

class RegularKnob<T> extends BuildableWritableKnob<T>
    with ValueGuardingKnobMixin<T>, ValueGuardingWritableKnobMixin<T> {
  RegularKnob({
    required super.label,
    required this.initialValue,
    required RegularKnobBuilder<T> knobBuilder,
    required this.rebuildKnobBuilderOnChange,
    required this.forceSpaciousLayout,
    this.trailingIconButton,
  }) : _knobBuilder = knobBuilder,
       super(initialValue: initialValue);

  final T initialValue;
  final RegularKnobBuilder<T> _knobBuilder;
  final bool rebuildKnobBuilderOnChange;
  final bool forceSpaciousLayout;
  final Widget? trailingIconButton;

  @override
  KnobSnapshot createSnapshot() => RegularKnobSnapshot(value: value);

  @override
  void tryLoadSnapshot(KnobSnapshot snapshot) {
    if (snapshot is RegularKnobSnapshot) {
      final snapshotValue = snapshot.value;
      if (snapshotValue is T) {
        value = snapshotValue;
      }
    }
  }

  @override
  void resetToInitial() {
    value = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildKnob() {
      return _knobBuilder(context, this);
    }

    return WControlItem(
      title: Text(label),
      trailing: trailingIconButton,
      control: rebuildKnobBuilderOnChange
          ? ListenableBuilder(
              listenable: this,
              builder: (context, _) => buildKnob(),
            )
          : buildKnob(),
      layout: forceSpaciousLayout
          ? ControlItemLayout.spacious
          : ControlItemLayout.compact,
    );
  }
}

class RegularKnobSnapshot extends KnobSnapshot {
  const RegularKnobSnapshot({required this.value});

  final Object? value;
}
