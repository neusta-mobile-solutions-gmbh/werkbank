> [!CAUTION]
> This topic is under construction.

<!--
TODO: Integrate this?

Knobs returned by `c.knobs.<knobType>` are of the type [Knob<T>](../werkbank/Knob-class.html).
The value of a knob can be read using the [`knob.value`](../werkbank/Knob/value.html) getter from
within the returned [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).
If the knob value changes the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
will be rebuilt automatically.

Knobs which control immutable values (such as `double` in this case) also implement
[WritableKnob<T>](../werkbank/WritableKnob-class.html), which allows
their value to be set using [`knob.value = ...`](../werkbank/WritableKnob/value.html) setter.

> [!IMPORTANT]
> Knob values cannot be read or modified above the returned
> [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
> and can therefore not influence anything done with the
> [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
> including the existence or label of other knobs.
> ```
-->

## Creating Custom Knobs

There are three ways to create your own knobs.
In increasing order, they become more complex, but also more powerful.

1. Write extensions using existing knobs.
   - Easy
   - Sufficient in most cases.
2. Use [makeRegularKnob](../werkbank/RegularKnobsExtension/makeRegularKnob.html) and
   [makeNullableKnob](../werkbank/NullableKnobsExtension/makeNullableKnob.html) to create a knob with a custom control widget.
   - Medium Difficulty
   - Only for knobs with **immutable** value type.
3. Use [registerKnob](../werkbank/KnobsComposer/registerKnob.html) to register a custom [Knob](../werkbank/Knob-class.html) implementation.
   - Hard
   - Allows you to create almost any knob you can imagine.

All approaches have in common that you introduce the knob method by writing an extension on
the [KnobsComposer](../werkbank/KnobsComposer-extension-type.html):
```dart
extension MyKnobExtension on KnobsComposer {
  WritableKnob<MyType> myKnob(
    String label, {
    required MyType initialValue,
      // Other parameters ...
    }) {
    // Implementation ...
  }
}
```

If it makes sense for your knob to have a nullable variant you should also write an extension on
[NullableKnobsComposer](../werkbank/NullableKnobsComposer-extension-type.html):
```dart
extension MyNullableKnobExtension on NullableKnobsComposer {
  WritableKnob<MyType?> myKnob(
    String label, {
    required MyType initialValue,
    bool initiallyNull = false,
      // Other parameters ...
    }) {
    // Implementation ...
  }
}
```

Avoid defining these extensions in the use case file where you need them.
Instead, put them in a separate file so that they can be reused in other use cases later.

By convention knobs have a single positional `label` parameter.
If they control immutable values, they should also have a required positional
`initialValue` parameter.
Their nullable variants should have an optional `initiallyNull` parameter defaulting to `false`.

For immutable values, the return type of the knob is usually
[WritableKnob](../werkbank/WritableKnob-class.html).
For mutable values it may just be [Knob](../werkbank/Knob-class.html) or
a more specific type if you choose the third approach and implement your own knob class.

The parameters and implementation depend on the type of knob you want to create and the approach you choose.

The following sections will explain the three approaches in more detail.

### Approach 1: Using Existing Knobs

Many existing knobs have some parameters that allow you to customize them in some way.
If you use a certain configuration often, you can write an extension
for a custom knob that uses an existing knob as a base and configures it
accordingly.

Especially versatile are knobs that can return any type `T`:
- [customSwitch](../werkbank/CustomSwitchKnobExtension/customSwitch.html)
- [customSlider](../werkbank/CustomSliderKnobExtension/customSlider.html)
- [customField](../werkbank/CustomFieldKnobExtension/customField.html)
- [customFieldMultiLine](../werkbank/CustomFieldMultiLineKnobExtension/customFieldMultiLine.html)
- [customDropdown](../werkbank/CustomDropdownKnobExtension/customDropdown.html)

These are intended to be used for writing custom knobs using extensions.
In fact, they are used to implement many of the other knobs.

However, sometimes it is sufficient to customize the labels of knobs with fixed types:
- [boolean](../werkbank/BooleanKnobExtension/boolean.html)
- [doubleSlider](../werkbank/DoubleKnobExtension/doubleSlider.html)
- [intSlider](../werkbank/IntKnobExtension/intSlider.html)

Here are some examples of how to use existing knobs to create custom knobs:

<details>
<summary><b>Example:</b> Percentage slider knob. (Uses <a href="../werkbank/DoubleKnobExtension/doubleSlider.html">doubleSlider</a>)</summary>

```dart
extension PercentageKnobExtension on KnobsComposer {
  WritableKnob<double> percentage(
    String label, {
      required double initialValue,
    }) {
    return doubleSlider(
      label,
      initialValue: initialValue,
      divisions: 100,
      valueLabel: (value) => '${(value * 100).toInt()}%',
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
      valueLabel: (value) => '${(value * 100).toInt()}%',
    );
  }
}
```
</details>

<details>
<summary><b>Example:</b> <a href="https://api.flutter.dev/flutter/dart-ui/Brightness.html">Brightness</a> switch knob. (Uses <a href="../werkbank/CustomSwitchKnobExtension/customSwitch.html">customSwitch</a>)</summary>

```dart
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
```
</details>

<details>
<summary><b>Example:</b> <a href="https://api.flutter.dev/flutter/material/TimeOfDay-class.html">TimeOfDay</a> slider knob. (Uses <a href="../werkbank/CustomSliderKnobExtension/customSlider.html">customSlider</a>)</summary>

```dart
extension TimeOfDayKnobExtension on KnobsComposer {
  WritableKnob<TimeOfDay> timeOfDay(
    String label, {
      required TimeOfDay initialValue,
      TimeOfDay min = const TimeOfDay(hour: 0, minute: 0),
      TimeOfDay max = const TimeOfDay(hour: 23, minute: 59),
    }) {
    return customSlider(
      label,
      initialValue: initialValue,
      min: min,
      max: max,
      divisions: 24 * 60 - 1,
      encoder: _timeOfDayEncoder,
      decoder: _timeOfDayDecoder,
      valueLabel: _timeOfDayFormatter,
    );
  }
}

extension NullableTimeOfDayKnobExtension on NullableKnobsComposer {
  WritableKnob<TimeOfDay?> timeOfDay(
    String label, {
      required TimeOfDay initialValue,
      bool initiallyNull = false,
      TimeOfDay min = const TimeOfDay(hour: 0, minute: 0),
      TimeOfDay max = const TimeOfDay(hour: 23, minute: 59),
    }) {
    return customSlider(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      min: min,
      max: max,
      divisions: 24 * 60 - 1,
      encoder: _timeOfDayEncoder,
      decoder: _timeOfDayDecoder,
      valueLabel: _timeOfDayFormatter,
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
```
</details>

<details>
<summary><b>Example:</b> <a href="https://api.dart.dev/dart-core/BigInt-class.html">BigInt</a> knob with a text field as input. (Uses <a href="../werkbank/CustomFieldKnobExtension/customField.html">customField</a>)</summary>

```dart
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
    : InputParseError('Invalid BigInt format');
}

String _bigIntInputFormatter(BigInt value) => value.toString();
```
</details>

<details>
<summary><b>Example:</b> <a href="https://api.flutter.dev/flutter/dart-ui/Color-class.html">Color</a> knob with a hex value text field as input. (Uses <a href="../werkbank/CustomFieldKnobExtension/customField.html">customField</a>)</summary>

```dart
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
    return InputParseError('Invalid hex color format');
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
```
</details>

<details>
<summary><b>Example:</b> <code>List&lt;String&gt;</code> knob. (Uses <a href="../werkbank/CustomFieldKnobExtension/customFieldMultiline.html">customFieldMultiline</a>)</summary>

```dart
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
```
</details>

<details>
<summary><b>Example:</b> <a href="https://api.flutter.dev/flutter/painting/AxisDirection.html">AxisDirection</a> knob. (Uses <a href="../werkbank/CustomDropdownKnobExtension/customDropdown.html">customDropdown</a>)</summary>

```dart
extension AxisDirectionKnobExtension on KnobsComposer {
  WritableKnob<AxisDirection> axisDirection(
    String label, {
    required AxisDirection initialValue,
  }) {
    return customDropdown(
      label,
      initialValue: initialValue,
      values: AxisDirection.values,
      valueLabel: _axisDirectionLabel,
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
      values: AxisDirection.values,
      valueLabel: _axisDirectionLabel,
    );
  }
}

String _axisDirectionLabel(AxisDirection direction) => switch (direction) {
  AxisDirection.up => 'Up',
  AxisDirection.down => 'Down',
  AxisDirection.left => 'Left',
  AxisDirection.right => 'Right',
};
```
</details>

### Approach 2: Using `makeRegularKnob` and `makeNullableKnob`

> [!CAUTION]
> Under construction.
> For now see how Werkbank uses these methods itself.

### Approach 3: Using `registerKnob`

> [!CAUTION]
> Under construction.
> For now see how Werkbank uses this method itself.
