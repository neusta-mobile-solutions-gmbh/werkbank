import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wSliderUseCase(UseCaseComposer c) {
  c
    ..description(
      'A slider that can be used to select a number '
      'within a certain range.',
    )
    ..tags([Tags.input]);

  c.constraints
    ..initial(width: 180)
    ..overview();

  final fraction = c.knobs.doubleSlider('Value', initialValue: 0.5);
  final min = c.knobs.doubleSlider(
    'Min',
    initialValue: 0,
    min: -8,
    max: 8,
  );
  final max = c.knobs.doubleSlider(
    'Max',
    initialValue: 1,
    min: -8,
    max: 8,
  );
  final divisions = c.knobs.nullable.intSlider(
    'Divisions',
    initialValue: 1,
    initiallyNull: true,
    min: 1,
    max: 24,
  );
  final formatPattern = c.knobs.string('Format Pattern', initialValue: '0.00');

  c
    ..knobPreset('Integer', () {
      min.value = 0;
      max.value = 10;
      divisions.value = 10;
      formatPattern.value = '#';
    })
    ..knobPreset('Percent', () {
      min.value = 0;
      max.value = 1;
      divisions.value = 100;
      formatPattern.value = '#%';
    })
    ..knobPreset('Pixel', () {
      min.value = 0;
      max.value = 100;
      divisions.value = null;
      formatPattern.value = "0.0 'px'";
    });

  return (context) {
    return WSlider(
      value: fraction.value * (max.value - min.value) + min.value,
      min: math.min(min.value, max.value),
      max: math.max(min.value, max.value),
      divisions: divisions.value,
      onChanged: (value) {
        fraction.setValue(
          ((value - min.value) / (max.value - min.value)).clamp(0, 1),
        );
      },
      valueFormatter: (value) =>
          NumberFormat(formatPattern.value).format(value),
    );
  };
}
