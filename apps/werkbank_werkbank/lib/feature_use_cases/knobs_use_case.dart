import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder knobsUseCase(UseCaseComposer c) {
  c
    ..description('''
# Knobs Use Case

A showcase of all supported knobs by the knobs addon.

## Overview

This use case demonstrates the various knobs supported by the knobs addon in the Werkbank package. Knobs allow you to dynamically adjust the properties of your widgets during development.

## Features
- **Boolean Knob**: A simple toggle switch.
- **Int Slider**: A slider for selecting integer values.
- **Double Slider**: A slider for selecting double values.
- **List Selector**: A dropdown for selecting from a list of options.
- **String Input**: A single-line text input.
- **Multi-line String Input**: A multi-line text input.
- **Milliseconds Input**: An input for duration in milliseconds.
- **Nullable Knobs**: All of the above knobs also have nullable variants.
- **Animation Controller Knob**: A knob for selecting an animation controller.
- **Interval Knob**: A knob for selecting an interval curve.
- **Curve Knob**: A knob for selecting a curve.
- **Curved Interval Knob**: A knob for selecting a curved interval curve.
- **Focus Node Knob**: A knob for selecting a focus node.
- **Focus Node Parent Knob**: A knob for selecting a focus node for a parent widget.
- **Focus Node Child Knob**: A knob for selecting a focus node for a child widget.
''')
    ..tags([Tags.knobs, Tags.useCase, Tags.addon])
    ..constraints.initial(width: 500)
    ..overview.withoutThumbnail();

  final booleanKnob = c.knobs.boolean('Boolean', initialValue: false);
  final nullableBooleanKnob = c.knobs.nullable.boolean(
    'Nullable Boolean',
    initialValue: false,
  );

  final intSliderKnob = c.knobs.intSlider('Int Slider', initialValue: 0);
  final nullableIntSliderKnob = c.knobs.nullable.intSlider(
    'Nullable Int Slider',
    initialValue: 0,
  );

  final doubleSliderKnob = c.knobs.doubleSlider(
    'Double Slider',
    initialValue: 0,
  );
  final nullableDoubleSliderKnob = c.knobs.nullable.doubleSlider(
    'Nullable Double Slider',
    initialValue: 0,
  );

  final listKnob = c.knobs.customDropdown(
    'List',
    initialValue: 'A',
    options: ['A', 'B', 'C'],
    optionLabel: (e) => e,
  );
  final nullableListKnob = c.knobs.nullable.customDropdown(
    'Nullable List',
    options: ['A', 'B', 'C'],
    optionLabel: (e) => e,
    initialValue: 'A',
  );

  final stringKnob = c.knobs.string('String', initialValue: 'Hello');
  final nullableStringKnob = c.knobs.nullable.string(
    'Nullable String',
    initialValue: 'Hello',
  );

  final stringMultiLineKnob = c.knobs.stringMultiLine(
    'String Multi Line',
    initialValue: 'Hello\nWorld',
  );
  final nullableStringMultiLineKnob = c.knobs.nullable.stringMultiLine(
    'Nullable String Multi Line',
    initialValue: 'Hello\nWorld',
  );

  final millisKnob = c.knobs.millis(
    'Milliseconds',
    initialValue: Durations.long1,
  );
  final nullableMillisKnob = c.knobs.nullable.millis(
    'Nullable Milliseconds',
    initialValue: Durations.long1,
  );

  final dateKnob = c.knobs.date('Date', initialValue: DateTime.now());
  final nullableDateKnob = c.knobs.nullable.date(
    'Nullable Date',
    initialValue: DateTime.now(),
  );

  final bigIntKnob = c.knobs.bigInt('BigInt Input', initialValue: BigInt.zero);
  final nullableBigIntKnob = c.knobs.nullable.bigInt(
    'Nullable BigInt Input',
    initialValue: BigInt.zero,
  );

  final hexColorKnob = c.knobs.hexColor('Hex Color', initialValue: Colors.red);
  final nullableHexColorKnob = c.knobs.nullable.hexColor(
    'Nullable Hex Color',
    initialValue: Colors.red,
  );

  final stringListKnob = c.knobs.stringList(
    'String List Input',
    initialValue: const ['Line 1', 'Line 2', 'Line 3'],
  );
  final nullableStringListKnob = c.knobs.nullable.stringList(
    'Nullable String List Input',
    initialValue: const ['Line 1', 'Line 2', 'Line 3'],
  );

  final timeOfDayKnob = c.knobs.timeOfDay(
    'Time Of Day',
    initialValue: const TimeOfDay(hour: 0, minute: 0),
  );
  final nullableTimeOfDayKnob = c.knobs.nullable.timeOfDay(
    'Nullable Time Of Day',
    initialValue: const TimeOfDay(hour: 0, minute: 0),
  );

  final brightnessKnob = c.knobs.brightness(
    'Brightness',
    initialValue: Brightness.dark,
  );
  final nullableBrightnessKnob = c.knobs.nullable.brightness(
    'Nullable Brightness',
    initialValue: Brightness.dark,
  );

  final percentageKnob = c.knobs.percentage('Percentage', initialValue: 0.5);
  final nullablePercentageKnob = c.knobs.nullable.percentage(
    'Nullable Percentage',
    initialValue: 0.5,
  );

  final axisDirectionKnob = c.knobs.axisDirection(
    'Axis Direction',
    initialValue: AxisDirection.up,
  );
  final nullableAxisDirectionKnob = c.knobs.nullable.axisDirection(
    'Nullable Axis Direction',
    initialValue: AxisDirection.up,
  );

  final animationControllerKnob = c.knobs.animationController(
    'Animation Controller',
    initialDuration: const Duration(seconds: 2),
  );

  final intervalKnob = c.knobs.interval(
    'Interval',
    initialValue: const Interval(0, .5),
  );
  final curveKnob = c.knobs.curve('Curve', initialValue: Curves.ease);
  final curvedIntervalKnob = c.knobs.curvedInterval(
    'CurvedInterval',
    initialValue: const Interval(0, 1, curve: Curves.ease),
  );

  final focusNodeKnob = c.knobs.focusNode('FocusNode');
  final focusNodeParentKnob = c.knobs.focusNode('FocusNode Parent');
  final focusNodeChildKnob = c.knobs.focusNode('FocusNode Child');

  c
    ..knobPreset('Focus Single Widget', () {
      focusNodeKnob.value.requestFocus();
    })
    ..knobPreset('Focus Nested Parent', () {
      focusNodeParentKnob.value.requestFocus();
    })
    ..knobPreset('Focus Nested Child', () {
      focusNodeChildKnob.value.requestFocus();
    });

  return (context) {
    final intervalAnimation = animationControllerKnob.value.drive(
      CurveTween(curve: intervalKnob.value),
    );
    final curvedAnimation = animationControllerKnob.value.drive(
      CurveTween(curve: curveKnob.value),
    );
    final curvedIntervalAnimation = animationControllerKnob.value.drive(
      CurveTween(curve: curvedIntervalKnob.value),
    );

    TextSpan knobSpan<T extends Object>(
      Knob<T> knob,
      Knob<T?> nullableKnob, [
      InlineSpan Function(T value)? valueSpan,
    ]) {
      final effectiveValueSpan =
          valueSpan ??
          (v) => TextSpan(
            text: v.toString(),
          );
      return TextSpan(
        children: [
          TextSpan(text: '${knob.label}: '),
          effectiveValueSpan(knob.value),
          const TextSpan(text: '\n'),
          TextSpan(text: '${nullableKnob.label}: '),
          if (nullableKnob.value != null)
            effectiveValueSpan(nullableKnob.value!)
          else
            const TextSpan(text: 'null'),
          const TextSpan(text: '\n'),
        ],
      );
    }

    final textSpans = [
      knobSpan(booleanKnob, nullableBooleanKnob),
      knobSpan(intSliderKnob, nullableIntSliderKnob),
      knobSpan(doubleSliderKnob, nullableDoubleSliderKnob),
      knobSpan(listKnob, nullableListKnob),
      knobSpan(stringKnob, nullableStringKnob),
      knobSpan(stringMultiLineKnob, nullableStringMultiLineKnob),
      knobSpan(millisKnob, nullableMillisKnob),
      knobSpan(dateKnob, nullableDateKnob),
      knobSpan(bigIntKnob, nullableBigIntKnob),
      knobSpan(
        hexColorKnob,
        nullableHexColorKnob,
        (v) => WidgetSpan(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: v,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const SizedBox(width: 16, height: 16),
          ),
        ),
      ),
      knobSpan(
        stringListKnob,
        nullableStringListKnob,
        (v) => TextSpan(
          text: v.map((e) => "'$e'").toList().toString(),
        ),
      ),
      knobSpan(timeOfDayKnob, nullableTimeOfDayKnob),
      knobSpan(brightnessKnob, nullableBrightnessKnob),
      knobSpan(percentageKnob, nullablePercentageKnob),
      knobSpan(axisDirectionKnob, nullableAxisDirectionKnob),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WTextArea.textSpan(
            textSpan: TextSpan(children: textSpans),
          ),
          const SizedBox(height: 16),
          RotationTransition(
            turns: intervalAnimation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
          RotationTransition(
            turns: curvedAnimation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.green,
            ),
          ),
          RotationTransition(
            turns: curvedIntervalAnimation,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            focusNode: focusNodeKnob.value,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            focusNode: focusNodeParentKnob.value,
            child: Switch(
              focusNode: focusNodeChildKnob.value,
              value: false,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  };
}

extension PercentageKnobExtension on KnobsComposer {
  WritableKnob<double> percentage(
    String label, {
    required double initialValue,
  }) {
    return doubleSlider(
      label,
      initialValue: initialValue,
      divisions: 100,
      valueFormatter: (value) => '${(value * 100).toInt()}%',
    );
  }
}

extension NullablePercentageKnobExtension on NullableKnobsComposer {
  WritableKnob<double?> percentage(
    String label, {
    required double initialValue,
    bool initiallyNull = false,
  }) {
    return doubleSlider(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      divisions: 100,
      valueFormatter: (value) => '${(value * 100).toInt()}%',
    );
  }
}

extension BrightnessKnobExtension on KnobsComposer {
  WritableKnob<Brightness> brightness(
    String label, {
    required Brightness initialValue,
  }) {
    return customSwitch(
      label,
      initialValue: initialValue,
      leftValue: Brightness.dark,
      rightValue: Brightness.light,
      leftLabel: 'DARK',
      rightLabel: 'LIGHT',
    );
  }
}

extension NullableBrightnessKnobExtension on NullableKnobsComposer {
  WritableKnob<Brightness?> brightness(
    String label, {
    required Brightness initialValue,
    bool initiallyNull = false,
  }) {
    return customSwitch(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      leftValue: Brightness.dark,
      rightValue: Brightness.light,
      leftLabel: 'DARK',
      rightLabel: 'LIGHT',
    );
  }
}

extension BigIntKnobExtension on KnobsComposer {
  WritableKnob<BigInt> bigInt(
    String label, {
    required BigInt initialValue,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      parser: _bigIntInputParser,
      formatter: _bigIntInputFormatter,
    );
  }
}

extension NullableBigIntKnobExtension on NullableKnobsComposer {
  WritableKnob<BigInt?> bigInt(
    String label, {
    required BigInt initialValue,
    bool initiallyNull = false,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      parser: _bigIntInputParser,
      formatter: _bigIntInputFormatter,
    );
  }
}

InputParseResult<BigInt> _bigIntInputParser(String input) {
  final trimmedInput = input.trim();
  if (trimmedInput.isEmpty) {
    return InputParseSuccess(BigInt.zero);
  }
  final parsedValue = BigInt.tryParse(trimmedInput);
  return parsedValue != null
      ? InputParseSuccess(parsedValue)
      : InputParseError('Invalid BigInt Format');
}

String _bigIntInputFormatter(BigInt value) => value.toString();

extension HexColorKnobExtension on KnobsComposer {
  WritableKnob<Color> hexColor(
    String label, {
    required Color initialValue,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      parser: _hexColorInputParser,
      formatter: _hexColorInputFormatter,
    );
  }
}

extension NullableHexColorKnobExtension on NullableKnobsComposer {
  WritableKnob<Color?> hexColor(
    String label, {
    required Color initialValue,
    bool initiallyNull = false,
  }) {
    return customField(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      parser: _hexColorInputParser,
      formatter: _hexColorInputFormatter,
    );
  }
}

final RegExp _hexColorRegExp = RegExp(
  r'^(#|0x)?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
);

InputParseResult<Color> _hexColorInputParser(String input) {
  final trimmedInput = input.trim();
  final match = _hexColorRegExp.firstMatch(trimmedInput);
  if (match == null) {
    return InputParseError('Invalid Hex Color Format');
  }
  final hex = match.group(2)!;
  final effectiveHex = hex.length == 6 ? 'FF$hex' : hex;
  return InputParseSuccess(Color(int.parse(effectiveHex, radix: 16)));
}

String _hexColorInputFormatter(Color value) {
  final argb32 = value.toARGB32();
  final String hex;
  if (argb32 >> 24 == 0xFF) {
    hex = argb32.toRadixString(16).substring(2);
  } else {
    hex = argb32.toRadixString(16).padLeft(8, '0');
  }
  return '#${hex.toUpperCase()}';
}

extension TimeOfDayKnobExtension on KnobsComposer {
  WritableKnob<TimeOfDay> timeOfDay(
    String label, {
    required TimeOfDay initialValue,
    TimeOfDay? min,
    TimeOfDay? max,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      min: min ?? const TimeOfDay(hour: 0, minute: 0),
      max: max ?? const TimeOfDay(hour: 23, minute: 59),
      divisions: 24 * 60,
      encoder: _timeOfDayEncoder,
      decoder: _timeOfDayDecoder,
      valueFormatter: _timeOfDayFormatter,
    );
  }
}

extension NullableTimeOfDayKnobExtension on NullableKnobsComposer {
  WritableKnob<TimeOfDay?> timeOfDay(
    String label, {
    required TimeOfDay initialValue,
    bool initiallyNull = false,
    TimeOfDay? min,
    TimeOfDay? max,
  }) {
    return customSlider(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      min: min ?? const TimeOfDay(hour: 0, minute: 0),
      max: max ?? const TimeOfDay(hour: 23, minute: 59),
      divisions: 24 * 60,
      encoder: _timeOfDayEncoder,
      decoder: _timeOfDayDecoder,
      valueFormatter: _timeOfDayFormatter,
    );
  }
}

TimeOfDay _timeOfDayDecoder(double value) {
  final hours = value ~/ 60;
  final minutes = (value % 60).toInt();
  return TimeOfDay(hour: hours, minute: minutes);
}

double _timeOfDayEncoder(TimeOfDay time) {
  return (time.hour * 60 + time.minute).toDouble();
}

String _timeOfDayFormatter(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}

extension StringListKnobExtension on KnobsComposer {
  WritableKnob<List<String>> stringList(
    String label, {
    required List<String> initialValue,
  }) {
    return customFieldMultiLine(
      label,
      initialValue: initialValue,
      parser: _stringListInputParser,
      formatter: _stringListInputFormatter,
    );
  }
}

extension NullableStringListKnobExtension on NullableKnobsComposer {
  WritableKnob<List<String>?> stringList(
    String label, {
    required List<String> initialValue,
    bool initiallyNull = false,
  }) {
    return customFieldMultiLine(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      parser: _stringListInputParser,
      formatter: _stringListInputFormatter,
    );
  }
}

InputParseResult<List<String>> _stringListInputParser(String input) {
  var lines = input.split('\n');
  if (lines.isNotEmpty && lines.last.isEmpty) {
    lines = lines.sublist(0, lines.length - 1);
  }
  return InputParseSuccess(lines);
}

String _stringListInputFormatter(List<String> value) =>
    value.join('\n') + (value.lastOrNull?.isEmpty ?? false ? '\n' : '');

extension AxisDirectionKnobExtension on KnobsComposer {
  WritableKnob<AxisDirection> axisDirection(
    String label, {
    required AxisDirection initialValue,
  }) {
    return customDropdown(
      label,
      initialValue: initialValue,
      options: AxisDirection.values,
      optionLabel: _axisDirectionLabel,
    );
  }
}

extension NullableAxisDirectionKnobExtension on NullableKnobsComposer {
  WritableKnob<AxisDirection?> axisDirection(
    String label, {
    required AxisDirection initialValue,
    bool initiallyNull = false,
  }) {
    return customDropdown(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      options: AxisDirection.values,
      optionLabel: _axisDirectionLabel,
    );
  }
}

String _axisDirectionLabel(AxisDirection direction) => switch (direction) {
  AxisDirection.up => 'Up',
  AxisDirection.down => 'Down',
  AxisDirection.left => 'Left',
  AxisDirection.right => 'Right',
};
