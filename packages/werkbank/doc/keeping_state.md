The [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) provides a generic, simple solution for managing any state. It's an alternative to using the [KnobsAddon](Knobs-topic.html) or the [WrappingAddon](../werkbank/WrappingAddon-class.html).

It is particularly useful for custom data models, controllers, or any state that doesn't have a corresponding knob implementation.

Using the [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html):
- Your state **preserves its value during hot reload**
- For **immutable objects**, you can update the state through [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)
- For **mutable objects**, the object's lifecycle will be handled for you

---

Here's a minimal example showing how to use *states*:

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
<summary><b>Example</b> of how you could achieve this <b>without the <a href="../werkbank/StateKeepingAddon-class.html">StateKeepingAddon</a></b></summary>

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

---

## Types of State

There are two types of state you can use with your use case:

- **Immutable state**
  - For example, a [`Color`](https://api.flutter.dev/flutter/dart-ui/Color-class.html), a [`Size`](https://api.flutter.dev/flutter/dart-ui/Size-class.html), [`Offset`](https://api.flutter.dev/flutter/dart-ui/Offset-class.html), or a custom data class
- **Mutable state**
  - For example, a [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html), [`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html), or another mutable object for managing state


### Immutable State

Use [`immutable`](../werkbank/StatesComposer/immutable.html) for values that are replaced entirely when changed, such as custom data classes or primitive values:

```dart
final componentModel = c.states.immutable(
  'Component Model',
  initialValue: MyComponentModel(
    title: 'Hello',
    count: 0,
    isEnabled: true,
  ),
);

// ...

componentModel.value = componentModel.value.copyWith(count: 1);
```

You can read and write *immutable states* through the [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) interface. When the `value` of an *immutable state* changes, the use case will rebuild.

### Mutable State

Use [`mutable`](../werkbank/StatesComposer/mutable.html) for objects that have internal state and need lifecycle management:

```dart
final scrollController = c.states.mutable(
  'Scroll Controller',
  create: () => ScrollController(),
  dispose: (controller) => controller.dispose(),
);


// ...

// Read-only access: the object is created once and managed internally
scrollController.value.animateTo(100);
```

*Mutable states* are provided by [`ValueContainer`](../werkbank/ValueContainer-class.html). The object is created once, survives hot reload, and is properly disposed when no longer needed. Unlike *immutable states*, you cannot reassign the value in your use case.
For objects that require a [`TickerProvider`](https://api.flutter.dev/flutter/scheduler/TickerProvider-class.html), use [`mutableWithTickerProvider`](../werkbank/StatesComposer/mutableWithTickerProvider.html).

## When to use the [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html), [KnobsAddon](Knobs-topic.html), or the [WrappingAddon](../werkbank/WrappingAddon-class.html)

- In comparison to the [KnobsAddon](Knobs-topic.html):
  - There is no need to implement something for each type, like a Knob of type String.
  - It doesn't offer visual controls.
- In comparison to the [WrappingAddon](../werkbank/WrappingAddon-class.html):
  - It offers watching and manipulating your object out of the box, without implementing something like a custom widget that serves this purpose.
  - It doesn't work by introducing new widgets to the widget tree. 
  
---

Use the **[KnobsAddon](Knobs-topic.html)** (first choice):
- When you need interactive controls in your Werkbank UI for testing different values.
- When there's an existing knob for your data type.
  - If you need a knob, but no suitable one exists, consider [implementing a custom knob](Knobs-topic.html) instead of using *states*.

Use the **[WrappingAddon](../werkbank/WrappingAddon-class.html)** when:
- You want to introduce a widget to the widget tree, like a [`DefaultTextStyle`](https://api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html), [`MediaQuery`](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html), or some custom [`InheritedWidget`](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html).

Else, use the **[StateKeepingAddon](../werkbank/StateKeepingAddon-class.html)**. It is particularly useful when:
- Working with Flutter controllers ([`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html), [`ScrollController`](https://api.flutter.dev/flutter/widgets/ScrollController-class.html), [`TabController`](https://api.flutter.dev/flutter/material/TabController-class.html)), or **custom mutable objects** like controllers.
- Managing immutable data models.
- You don't need interactive controls in your Werkbank UI.
- Quick prototyping where implementing a custom knob would be overkill.
