import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knob_types/regular_knob.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/curve_knob_widget.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/curves_info_button.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/interval_knob_widget.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/predefined_curves.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/update_curve_knob_state.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/update_interval_knob_state.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/named_curve.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs_composer.dart';

/// {@category Knobs}
extension CurvedIntervalKnobExtension on KnobsComposer {
  WritableKnob<Interval> curvedInterval(
    String label, {
    Interval initialValue = const Interval(0, 1),
    List<NamedCurve> curveOptions = predefinedCurves,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CurvedIntervalKnob(
        valueNotifier: valueNotifier,
        curveOptions: curveOptions,
        initialValue: initialValue,
      ),
      trailingIconButton: const CurvesInfoButton(),
    );
  }
}

class _CurvedIntervalKnob extends StatelessWidget
    with UpdateCurveKnobState, UpdateIntervalKnobState {
  const _CurvedIntervalKnob({
    required this.valueNotifier,
    required this.curveOptions,
    required this.initialValue,
  });

  final ValueNotifier<Interval> valueNotifier;
  final List<NamedCurve> curveOptions;
  final Interval initialValue;

  @override
  Widget build(BuildContext context) {
    final (:currentCurve, :allCurves) = updateCurveKnobState(
      curveOptions,
      valueNotifier.value.curve,
      initialValue.curve,
    );

    final (
      :currentInterval,
      :beginOptions,
      :endOptions,
    ) = updateIntervalKnobState(
      currentValue: valueNotifier.value,
      initialValue: initialValue,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntervalKnobWidget(
          currentInterval: currentInterval,
          beginOptions: beginOptions,
          endOptions: endOptions,
          onBeginChanged: (namedBegin) {
            namedBegin!;
            valueNotifier.value = Interval(
              namedBegin.value,
              currentInterval.end.value,
              curve: valueNotifier.value.curve,
            );
          },
          onEndChanged: (namedEnd) {
            namedEnd!;
            valueNotifier.value = Interval(
              currentInterval.begin.value,
              namedEnd.value,
              curve: valueNotifier.value.curve,
            );
          },
        ),
        const SizedBox(height: 4),
        CurveKnobWidget(
          currentCurve: currentCurve,
          allCurves: allCurves,
          onChanged: (value) {
            value!;
            final interval = valueNotifier.value;
            valueNotifier.value = Interval(
              interval.begin,
              interval.end,
              curve: value.curve,
            );
          },
        ),
      ],
    );
  }
}
