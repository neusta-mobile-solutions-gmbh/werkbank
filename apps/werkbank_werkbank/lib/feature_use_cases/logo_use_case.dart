import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/nms/nms_logo.dart';

WidgetBuilder logoUseCase(UseCaseComposer c) {
  final color = c.knobs.list<NmsOrbColor>(
    'Color',
    options: NmsOrbColor.values,
    optionLabel: (e) => e.name,
    initialOption: NmsOrbColor.farbig,
  );
  return (context) {
    return NmsLogo(
      color: color.value,
    );
  };
}
