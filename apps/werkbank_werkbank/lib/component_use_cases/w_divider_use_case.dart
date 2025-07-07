import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wDividerUseCase(UseCaseComposer c) {
  c.description(
    'A divider with a configurable axis.',
  );

  final axis = c.knobs.list(
    'Axis',
    initialValue: Axis.horizontal,
    options: Axis.values,
    optionLabel: (axis) => switch (axis) {
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
