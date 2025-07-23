The States addon provides a simple solution for managing state that doesn't need visual controls in the knobs panel. Think of it as "headless knobs" - you get the same reactive state management capabilities as knobs, but without the UI controls. This is particularly useful for custom data models, controllers, or any state that doesn't have a corresponding knob implementation.

States behave similarly to knobs: they preserve their values during hot reloads, provide reactive updates through `ValueNotifier`, and integrate seamlessly with your use cases. The key difference is that states don't appear as controllable elements in the right panel.

## When to Use States vs. Knobs

**Always prefer knobs when a suitable one exists.** Knobs provide interactive controls that make testing and experimentation much easier.

Use **knobs** (first choice):
- When there's an existing knob for your data type
- When you need interactive controls for testing different values

Use **states** when:
- No suitable knob exists for your data type and you don't need user controls
- Working with Flutter controllers (`TextEditingController`, `ScrollController`, `TabController`) or custom controllers
- Managing custom data models that don't require interactive manipulation
- Quick prototyping where implementing a custom knob would be overkill

If you need a control but no suitable knob exists, consider [implementing a custom knob](knobs.html) instead of using states.

## Types of States

There are three types of state containers available:

### Immutable States

Use [`immutable`](../werkbank/StatesComposer/immutable.html) for values that are replaced entirely when changed, such as custom data classes or primitive values:

```dart
// ---- lib/example_use_case.dart ---- //

final componentModel = c.states.immutable(
  'Component Model',
  initialValue: MyComponentModel(
    title: 'Hello',
    count: 0,
    isEnabled: true,
  ),
);

// Use componentModel.value just like with knobs
```

### Mutable States

Use [`mutable`](../werkbank/StatesComposer/mutable.html) for objects that have internal state and need lifecycle management:

```dart
final scrollController = c.states.mutable(
  'Scroll Controller', 
  create: () => ScrollController(),
  dispose: (controller) => controller.dispose(),
);
```

### Mutable States with Ticker Provider

Use [`mutableWithTickerProvider`](../werkbank/StatesComposer/mutableWithTickerProvider.html) for objects that require a `TickerProvider`, such as animation controllers:

```dart
final tabController = c.states.mutableWithTickerProvider(
  'Tab Controller',
  create: (tickerProvider) => TabController(
    length: 3,
    vsync: tickerProvider,
  ),
  dispose: (controller) => controller.dispose(),
);
```

> [!NOTE]
> All state values are preserved during hot reloads, just like knobs. This makes iterative development smooth and efficient.

