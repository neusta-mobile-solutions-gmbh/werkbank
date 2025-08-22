This topic shows you multiple ways to keep state in your use cases.

**Table of Contents:**
- [Ways to Keep State](#ways-to-keep-state)
- [Knobs](#knobs)
- [StateKeepingAddon](#statekeepingaddon)
  - [Keeping Immutable State](#keeping-immutable-state)
  - [Keeping Mutable State](#keeping-mutable-state)

## Ways to Keep State

When writing a use case, you may come across widgets that require you to keep some changing state outside the widget.
This state usually comes in one of two forms:
- **Immutable state**: Often passed as a pair of a `value` and `onValueChanged` callback into the widget.
- **Mutable state**: Often a controller or another object that has its own lifecycle and needs to be created and disposed of.

A naive way to keep this state is to wrap your returned use case widget in a [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
and manage the state there.
However, this requires a lot of boilerplate code.
*Do not do this!*

Instead, Werkbank provides better alternatives to keep state in your use case:
- [Knobs](Knobs-topic.html) keep state in a way that allows you to interactively change it in the Werkbank UI.
  - This is the first choice if the type of your state has a corresponding knob.
- The [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) allows you to store any immutable or mutable state in your use case.
  - This is particularly useful for custom data models, controllers, or any type that doesn't have a corresponding knob.

## Knobs

Learn all about knobs in the [Knobs topic](Knobs-topic.html)
or read a summary in the Knobs section of the [Writing Use Cases](../werkbank/Writing%20Use%20Cases-topic.html#knobs) topic.

Prefer using knobs to keep state:
- When you need interactive controls in your Werkbank UI for testing different values.
- When there's an existing knob for your data type.
  - If you need a knob, but no suitable one exists, consider [implementing a custom knob](Knobs-topic.html#creating-custom-knobs).

## StateKeepingAddon

The [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) should be used to keep state when:
- Working with Flutter controllers ([`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html), [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html), [`TabController`](https://api.flutter.dev/flutter/material/TabController-class.html)), or **custom mutable objects** like controllers.
- Managing immutable data models.
- You don't need interactive controls in your Werkbank UI.
- Doing quick prototyping where implementing a custom knob would be overkill.

This example keeps a [Color](https://api.flutter.dev/flutter/dart-ui/Color-class.html) and a
[`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
for the use case:

```dart
WidgetBuilder myColorPickerUseCase(UseCaseComposer c) {
  // Keep immutable state in a ValueNotifier
  final colorNotifier = c.states.immutable(
    'Color',
    initialValue: Colors.red,
  );

  // Keep mutable state and provide functions to create and dispose it.
  final hexControllerContainer = c.states.mutable(
    'Hex Controller',
    create: TextEditingController.new,
    dispose: (controller) => controller.dispose(),
  );

  return (context) {
    return MyColorPicker(
      // Get and set the color using the ValueNotifier
      color: colorNotifier.value,
      onColorChanged: (newColor) => colorNotifier.value = newColor,
      // Unpack the returned ValueContainer to get the TextEditingController
      hexColorController: hexControllerContainer.value,
    );
  };
}
```

<details>
<summary><b>Equivalent example</b> without using the <a href="../werkbank/StateKeepingAddon-class.html">StateKeepingAddon</a>.</summary>

This illustrates what issue the [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) solves for you, since **you don't have to do this**:

```dart
WidgetBuilder myColorPickerUseCase(UseCaseComposer c) {
  return (context) {
    return _MyColorPickerStateProvider(
      builder: (context, color, setColor, hexColorController) {
        return MyColorPicker(
          color: color,
          onColorChanged: setColor,
          hexColorController: hexColorController,
        );
      },
    );
  };
}

class _MyColorPickerStateProvider extends StatefulWidget {
  const _MyColorPickerStateProvider({
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    Color color,
    ValueChanged<Color> setColor,
    TextEditingController hexColorController,
    )
  builder;

  @override
  State<_MyColorPickerStateProvider> createState() =>
    _MyColorPickerStateProviderState();
}

class _MyColorPickerStateProviderState
  extends State<_MyColorPickerStateProvider> {
  Color _color = Colors.red;
  final TextEditingController _hexColorController = TextEditingController();

  @override
  void dispose() {
    _hexColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _color,
        (newColor) {
        setState(() {
          _color = newColor;
        });
      },
      _hexColorController,
    );
  }
}
```
</details>

There are two types of state you can can store in your use case:
- **Immutable state**
  - For example, an
    [`int`](https://api.flutter.dev/flutter/dart-core/int-class.html),
    [`String`](https://api.flutter.dev/flutter/dart-core/String-class.html),
    [`Color`](https://api.flutter.dev/flutter/dart-ui/Color-class.html),
    or a custom data class
- **Mutable state**
  - For example, a [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html),
    [`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html),
    [`FocusNode`](https://api.flutter.dev/flutter/widgets/FocusNode-class.html),
    or another mutable object that manges its own state.

### Keeping Immutable State

Use [`c.immutable(...)`](../werkbank/StatesComposer/immutable.html) for values that are replaced entirely when changed, such as custom data classes or primitive values:

```dart
final componentModel = c.states.immutable(
  'Component Model',
  initialValue: MyComponentModel(
    title: 'Hello',
    count: 0,
    isEnabled: true,
  ),
);

// Within the WidgetBuilder of your use case:

componentModel.value = componentModel.value.copyWith(count: 1);
```

You can read and write *immutable states* through the [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) interface. When the `value` of an *immutable state* changes, the use case will rebuild.

### Keeping Mutable State

Use [`c.mutable(...)`](../werkbank/StatesComposer/mutable.html) for objects that have internal state and need lifecycle management:

```dart
final scrollController = c.states.mutable(
  'Scroll Controller',
  create: () => ScrollController(),
  dispose: (controller) => controller.dispose(),
);

// Within the WidgetBuilder of your use case:

// Read-only access: the object is created once and managed internally
scrollController.value.animateTo(100);
```

*Mutable states* are provided by [`ValueContainer`](../werkbank/ValueContainer-class.html). The object is created once, survives hot reload, and is properly disposed when no longer needed. Unlike *immutable states*, you cannot reassign the value in your use case.
For objects that require a [`TickerProvider`](https://api.flutter.dev/flutter/scheduler/TickerProvider-class.html), use [`mutableWithTickerProvider`](../werkbank/StatesComposer/mutableWithTickerProvider.html).


