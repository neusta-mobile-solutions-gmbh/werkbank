import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

typedef NullableKnobBuilder<T extends Object> =
    Widget Function(
      BuildContext context,
      // ignore: avoid_positional_boolean_parameters
      bool enabled,
      ValueNotifier<T> valueNotifier,
    );

@Deprecated('Use NullableKnobsComposer instead')
typedef NullableKnobs = NullableKnobsComposer;

extension type NullableKnobsComposer(KnobsComposer _knobs) {
  WritableKnob<T?> makeNullableKnob<T extends Object>(
    String label, {
    required T initialValue,
    required bool initiallyNull,
    bool forceSpaciousLayout = false,
    required NullableKnobBuilder<T> knobBuilder,
    bool rebuildKnobBuilderOnChange = true,
  }) {
    final knob = NullableKnob<T>(
      label: label,
      initialNonNullableValue: initialValue,
      isInitiallyNull: initiallyNull,
      knobBuilder: knobBuilder,
      rebuildKnobBuilderOnChange: rebuildKnobBuilderOnChange,
      forceSpaciousLayout: forceSpaciousLayout,
    );
    _knobs.registerKnob(knob);
    return knob;
  }
}

extension NullableKnobsExtension on KnobsComposer {
  /// Returns a [NullableKnobsComposer] with many methods to create nullable
  /// knobs for the use case.
  NullableKnobsComposer get nullable => NullableKnobsComposer(this);
}

class NullableKnob<T extends Object> extends BuildableWritableKnob<T?>
    with ValueGuardingKnobMixin<T?>, ValueGuardingWritableKnobMixin<T?> {
  NullableKnob({
    required super.label,
    required this.initialNonNullableValue,
    required this.isInitiallyNull,
    required NullableKnobBuilder<T> knobBuilder,
    required this.rebuildKnobBuilderOnChange,
    required this.forceSpaciousLayout,
  }) : _knobBuilder = knobBuilder,
       nonNullableValueNotifier = ValueNotifier<T>(initialNonNullableValue),
       super(
         initialValue: isInitiallyNull ? null : initialNonNullableValue,
       ) {
    nonNullableValueNotifier.addListener(() {
      if (value != null) {
        value = nonNullableValueNotifier.value;
      }
    });
    addListener(() {
      if (value != null) {
        nonNullableValueNotifier.value = value!;
      }
    });
  }

  final T initialNonNullableValue;
  final bool isInitiallyNull;
  final NullableKnobBuilder<T> _knobBuilder;
  final bool rebuildKnobBuilderOnChange;

  final ValueNotifier<T> nonNullableValueNotifier;

  final bool forceSpaciousLayout;

  @override
  KnobSnapshot createSnapshot() => NullableKnobSnapshot(
    nonNullableValue: nonNullableValueNotifier.value,
    isNull: value == null,
  );

  @override
  void tryLoadSnapshot(KnobSnapshot snapshot) {
    if (snapshot is NullableKnobSnapshot) {
      if (snapshot.isNull) {
        value = null;
      }
      final nonNullableSnapshotValue = snapshot.nonNullableValue;
      if (nonNullableSnapshotValue is T) {
        nonNullableValueNotifier.value = nonNullableSnapshotValue;
        if (!snapshot.isNull) {
          value = nonNullableSnapshotValue;
        }
      }
    }
  }

  @override
  void resetToInitial() {
    value = isInitiallyNull ? null : initialNonNullableValue;
    nonNullableValueNotifier.value = initialNonNullableValue;
  }

  @override
  void dispose() {
    nonNullableValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(label),
      control: MappingValueListenableBuilder(
        valueListenable: this,
        mapper: (value) => value == null,
        builder: (context, isNull, _) {
          Widget buildKnob() => _knobBuilder(
            context,
            !isNull,
            nonNullableValueNotifier,
          );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: rebuildKnobBuilderOnChange
                    ? ListenableBuilder(
                        listenable: nonNullableValueNotifier,
                        builder: (context, _) => buildKnob(),
                      )
                    : buildKnob(),
              ),
              const SizedBox(width: 2),
              WIconButton(
                isActive: isNull,
                onPressed: () {
                  if (isNull) {
                    value = nonNullableValueNotifier.value;
                  } else {
                    value = null;
                  }
                },
                icon: const Icon(WerkbankIcons.circle),
                activeIcon: const Icon(WerkbankIcons.empty),
              ),
            ],
          );
        },
      ),
      layout: forceSpaciousLayout
          ? ControlItemLayout.spacious
          : ControlItemLayout.compact,
    );
  }
}

class NullableKnobSnapshot extends KnobSnapshot {
  const NullableKnobSnapshot({
    required this.nonNullableValue,
    required this.isNull,
  });

  final Object nonNullableValue;
  final bool isNull;
}
