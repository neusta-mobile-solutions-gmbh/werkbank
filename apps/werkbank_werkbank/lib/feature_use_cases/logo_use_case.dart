import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/nms/nms_logo.dart';

WidgetBuilder logoUseCase(UseCaseComposer c) {
  final color = c.knobs.customDropdown<NmsOrbColor>(
    'Color',
    initialValue: NmsOrbColor.farbig,
    options: NmsOrbColor.values,
    optionLabel: (e) => e.name,
  );
  return (context) {
    return NmsLogo(
      color: color.value,
    );
  };
}
