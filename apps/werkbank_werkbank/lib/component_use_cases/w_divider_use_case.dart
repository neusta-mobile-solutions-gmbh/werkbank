import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wDividerUseCase(UseCaseComposer c) {
  c.description(
    'A divider with a configurable axis.',
  );

  final axis = c.knobs.customDropdown(
    'Axis',
    initialValue: Axis.horizontal,
    values: Axis.values,
    valueLabel: (axis) => switch (axis) {
      Axis.horizontal => 'Horizontal',
      Axis.vertical => 'Vertical',
    },
  );
  return (context) {
    return WDivider(
      axis: axis.value,
    );
  };
}
