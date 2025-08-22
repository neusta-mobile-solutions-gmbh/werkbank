This topic shows you multiple ways to keep state in your use cases.

**Table of Contents:**
- [Ways to Keep State](#ways-to-keep-state)
- [Knobs](#knobs)
- [StateKeepingAddon](#statekeepingaddon)
  - [Keeping Immutable State](#keeping-immutable-state)
  - [Keeping Mutable State](#keeping-mutable-state)

## Ways to Keep State

When writing a use case, you may encounter widgets that require you to keep changing state outside the widget.
This state usually comes in one of two forms:
- **Immutable state**: Often passed as a pair of a `value` and `onValueChanged` callback into the widget.
  - Example types are:
    [`int`](https://api.flutter.dev/flutter/dart-core/int-class.html),
    [`String`](https://api.flutter.dev/flutter/dart-core/String-class.html),
    [`Color`](https://api.flutter.dev/flutter/dart-ui/Color-class.html),
    or a custom data classes.
- **Mutable state**: Often a controller or another object that has its own lifecycle and needs to be created and disposed of.
  - Example types are:
    [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html),
    [`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html),
    [`FocusNode`](https://api.flutter.dev/flutter/widgets/FocusNode-class.html),
    or other objects that mange their own state.


A naive way to keep this state is to wrap your returned use case widget in a [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
and manage the state there.
However, this approach requires a lot of boilerplate code.
*Do not do this!*

Instead, Werkbank provides better alternatives to keep state in your use case:
- [Knobs](Knobs-topic.html) keep state in a way that allows you to interactively change values in the Werkbank UI.
  - Consider using knobs first if the type of your state has a corresponding knob.
- The [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) allows you to store any immutable or mutable state in your use case.
  - Use this addon for custom data models, controllers, or any type that doesn't have a corresponding knob.

## Knobs

Learn all about knobs in the [Knobs topic](Knobs-topic.html)
or read a summary in the Knobs section of the [Writing Use Cases](../werkbank/Writing%20Use%20Cases-topic.html#knobs) topic.

Prefer using knobs to keep state:
- When you need interactive controls in your Werkbank UI for testing different values.
- When there is an existing knob for your data type.
  - If you need a knob but no suitable one exists, consider [implementing a custom knob](Knobs-topic.html#creating-custom-knobs).

## StateKeepingAddon

Use the [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) to keep state when:
- Working with Flutter controllers ([`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html), [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html), [`TabController`](https://api.flutter.dev/flutter/material/TabController-class.html)), or **custom mutable objects** like controllers.
- Managing immutable data models.
- You don't need interactive controls in your Werkbank UI.
- Doing quick prototyping where implementing a custom knob would be overkill.

This example keeps a [Color](https://api.flutter.dev/flutter/dart-ui/Color-class.html) and a
[TextEditingController](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
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
      (newColor) => setState(() => color = newColor),
      _hexColorController,
    );
  }
}
```

</details>

### Keeping Immutable State

Use [`c.immutable(...)`](../werkbank/StatesComposer/immutable.html) to store immutable state.
This method returns a [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) that you can read from and write to.

```dart
WidgetBuilder myCounterUseCase(UseCaseComposer c) {
  final counterNotifier = c.states.immutable(
    'Counter',
    initialValue: 0,
  );

  return (context) {
    return MyCounter(
      counter: counterNotifier.value,
      onIncrement: () => counterNotifier.value++,
      onDecrement: () => counterNotifier.value--,
    );
  };
}
```

You can read and write the value of the [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) only inside the returned [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).
When the `value` of an *immutable state* changes, the use case will rebuild.

### Keeping Mutable State

Use [`c.mutable(...)`](../werkbank/StatesComposer/mutable.html) to store mutable state.
This method returns a [`ValueContainer`](../werkbank/ValueContainer-class.html) that holds your mutable object.

The [mutable](../werkbank/StatesComposer/mutable.html) method requires:
- A `create` callback that creates the object.
- A `dispose` callback that properly disposes of the object.

```dart
WidgetBuilder myTextFieldUseCase(UseCaseComposer c) {
  final scrollControllerContainer = c.states.mutable(
    'Scroll Controller',
    create: () => ScrollController(),
    dispose: (controller) => controller.dispose(),
  );

  return (context) {
    return MyScrollView(
      scrollController: scrollControllerContainer.value,
      onScrollToTopPressed: () => scrollControllerContainer.value.animateTo(0),
    );
  };
}
```

You can read the [value](../werkbank/ValueContainer/value.html) of the [`ValueContainer`](../werkbank/ValueContainer-class.html) only inside the returned [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).
Unlike with immutable states, you cannot reassign the value of a [`ValueContainer`](../werkbank/ValueContainer-class.html) later. You can only mutate the contained value.
Doing so will not trigger a rebuild of the use case.

Use [`c.mutableWithTickerProvider(...)`](../werkbank/StatesComposer/mutableWithTickerProvider.html) for objects that require a [`TickerProvider`](https://api.flutter.dev/flutter/scheduler/TickerProvider-class.html).
