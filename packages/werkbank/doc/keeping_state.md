The [StateAddon](../werkbank/StateAddon-class.html) provides a general, simple solution for managing any state. It's an alternative to using the [KnobsAddon](Knobs-topic.html) or the [WrappingAddon](../werkbank/WrappingAddon-class.html). 

It is is particularly useful for custom data models, controllers, or any state that doesn't have a corresponding knob implementation.

Using the [StateAddon](../werkbank/StateAddon-class.html):
- Your state **preserves its values during hot reloads**
- For **immutable objects**, you can update the state through `ValueNotifier`
- For **mutable objects**, the lifecycle will be handled for you
  
---

Here's a minimal example showing how to use states:

```dart
WidgetBuilder statesExampleUseCase(UseCaseComposer c) {
  // Immutable state for custom data model
  final customModel = c.states.immutable(
    'UI Model',
    initialValue: CustomModel(
      isLoading: false,
      itemCount: 5,
    ),
  );

  // Mutable state for controller
  final textController = c.states.mutable(
    'Text Controller',
    create: TextEditingController.new,
    dispose: (controller) => controller.dispose(),
  );

  return (context) {
    return Column(
      children: [
        _CustomComponent(
          model: customModel.value,
          onModelChanged: (newModel) {
            customModel.value = newModel;
          },
        ),
        TextField(controller: textController.value),
      ],
    );
  };
}
```

<details>
<summary><b>Example</b> of how you could achieve this <b>without the StateAddon</b></summary>

This illustrates what issue the StateAddon solves for you, since **you don't have to do this**:

```dart
WidgetBuilder exampleWithoutStatesUseCase(UseCaseComposer c) {
  return (context) {
    return _StateProvider(
      builder: (context, model, controller) => Column(
        children: [
          _CustomComponent(
            model: model.value,
            onModelChanged: (newModel) {
              model.value = newModel;
            },
          ),
          TextField(controller: controller),
        ],
      ),
    );
  };
}

class _StateProvider extends StatefulWidget {
  const _StateProvider({
    required this.builder,
  });

  final Widget Function(
    BuildContext context,
    ValueNotifier<CustomModel> model,
    TextEditingController controller,
  ) builder;

  @override
  State<_StateProvider> createState() => _StateProviderState();
}

class _StateProviderState extends State<_StateProvider> {
  late final ValueNotifier<CustomModel> _model;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _model = ValueNotifier(CustomModel());
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _model, _controller);
  }
}
```
</details>

---

## Types of State

There are two types of state you may want to keep for your use case:

- **Immutable state**
  - For example for a `Color`, a `Size`, `Offset`, or a custom data class
- **Mutable state**
  - For example for a `ScrollController`, `TextEditingController`, or another mutable object for managing state.


### Immutable State

Use [`immutable`](../werkbank/StatesComposer-class.html) for values that are replaced entirely when changed, such as custom data classes or primitive values:

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

You can read and write immutable states through the `ValueNotifier` interface. When the `value` of an immutable state changes, the Use Case will rebuild.

### Mutable State

Use [`mutable`](../werkbank/StatesComposer-class.html) for objects that have internal state and need lifecycle management:

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

Mutable states are provided by [`ValueContainer`](../werkbank/ValueContainer-class.html). The object is created once via `create`, survives hot reloads, and is properly disposed when no longer needed. Unlike immutable states, you cannot reassign the value in your use case.
For objects that require a `TickerProvider`, use [`mutableWithTickerProvider`](../werkbank/StatesComposer-class.html).

## When to use the StateAddon, KnobsAddon, or the WrappingAddon

- In comparision to the **KnobsAddon**
  - There is no need to implement something for each type, like a Knob of type String
  - it doesn't offer visual controls.
- In comparision to the **WrappingAddon**
  - It offers watching and manipulating your object out of the box, without implementing something instance a custom widget, like in the following example, that serves this purpose.
  - It doesn't work by introducing new widgets to the widget tree 
  
---

Use **knobs** (first choice):
- When you need interactive controls in your Werkbank UI for testing different values.
- When there's an existing knob for your data type
  - If you need a knob, but no suitable exists, consider [implementing a custom knob](Knobs-topic.html) instead of using states.

Use the **WrappingAddon** when:
- You want to introduce a widget to the widget-tree, like a `DefaultTextStyle`, `MediaQuery`, or some custom `InheritedWidget`.

Else, use **states**. It is particularly useful when:
- Working with Flutter controllers (`TextEditingController`, `ScrollController`, `TabController`), or **custom mutable objects** like controllers.
- Managing immutable data models.
- You don't need interactive controls in your Werkbank UI.
- Quick prototyping where implementing a custom knob would be overkill.
