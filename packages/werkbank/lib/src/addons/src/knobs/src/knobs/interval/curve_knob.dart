import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/curve_knob_widget.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/curves_info_button.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/predefined_curves.dart';
import 'package:werkbank/src/addons/src/knobs/src/knobs/interval/_internal/update_curve_knob_state.dart';
import 'package:werkbank/werkbank_old.dart';

/// {@category Knobs}
extension CurveKnobExtension on KnobsComposer {
  WritableKnob<Curve> curve(
    String label, {
    Curve initialValue = Curves.linear,
    List<NamedCurve> curveOptions = predefinedCurves,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _CurveKnob(
        valueNotifier: valueNotifier,
        curveOptions: curveOptions,
        initialValue: initialValue,
      ),
      trailingIconButton: const CurvesInfoButton(),
    );
  }
}

class _CurveKnob extends StatelessWidget with UpdateCurveKnobState {
  const _CurveKnob({
    required this.valueNotifier,
    required this.curveOptions,
    required this.initialValue,
  });

  final ValueNotifier<Curve> valueNotifier;
  final List<NamedCurve> curveOptions;
  final Curve initialValue;

  @override
  Widget build(BuildContext context) {
    final (:currentCurve, :allCurves) = updateCurveKnobState(
      curveOptions,
      valueNotifier.value,
      initialValue,
    );

    return CurveKnobWidget(
      currentCurve: currentCurve,
      allCurves: allCurves,
      onChanged: (value) {
        value!;
        valueNotifier.value = value.curve;
      },
    );
  }
}
