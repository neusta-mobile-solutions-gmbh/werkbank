import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob_types/regular_knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/interval_knob_widget.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/update_interval_knob_state.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs_composer.dart';

/// {@category Knobs}
extension IntervalKnobExtension on KnobsComposer {
  WritableKnob<Interval> interval(
    String label, {
    Interval initialValue = const Interval(0, 1),
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _IntervalKnob(
        valueNotifier: valueNotifier,
        initialValue: initialValue,
      ),
    );
  }
}

class _IntervalKnob extends StatelessWidget with UpdateIntervalKnobState {
  const _IntervalKnob({
    required this.valueNotifier,
    required this.initialValue,
  });

  final ValueNotifier<Interval> valueNotifier;
  final Interval initialValue;

  @override
  Widget build(BuildContext context) {
    final (
      :currentInterval,
      :beginOptions,
      :endOptions,
    ) = updateIntervalKnobState(
      currentValue: valueNotifier.value,
      initialValue: initialValue,
    );

    return IntervalKnobWidget(
      currentInterval: currentInterval,
      beginOptions: beginOptions,
      endOptions: endOptions,
      onBeginChanged: (namedBegin) {
        namedBegin!;
        valueNotifier.value = Interval(
          namedBegin.value,
          currentInterval.end.value,
        );
      },
      onEndChanged: (namedEnd) {
        namedEnd!;
        valueNotifier.value = Interval(
          currentInterval.begin.value,
          namedEnd.value,
        );
      },
    );
  }
}
