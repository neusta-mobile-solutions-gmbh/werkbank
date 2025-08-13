import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';

mixin UpdateCurveKnobState {
  ({NamedCurve currentCurve, List<NamedCurve> allCurves}) updateCurveKnobState(
    List<NamedCurve> predefinedCurves,
    Curve currentValue,
    Curve initialValue,
  ) {
    final NamedCurve currentCurve;
    final allNamedCurves = [
      ...predefinedCurves,
    ];
    final initialCurveIsNotPredefined = !allNamedCurves
        .map((e) => e.curve)
        .contains(initialValue);
    if (initialCurveIsNotPredefined) {
      allNamedCurves.add(
        NamedCurve('Initial Custom Curve', null, initialValue),
      );
    }
    final currentCurveIsNotDefined = !allNamedCurves
        .map((e) => e.curve)
        .contains(currentValue);
    if (currentCurveIsNotDefined) {
      final customCurve = NamedCurve('Custom Curve', null, currentValue);
      allNamedCurves.add(customCurve);
      currentCurve = customCurve;
    } else {
      // current curve is defined
      currentCurve = allNamedCurves.firstWhere(
        (namedCurve) => namedCurve.curve == currentValue,
      );
    }
    return (
      currentCurve: currentCurve,
      allCurves: allNamedCurves,
    );
  }
}
