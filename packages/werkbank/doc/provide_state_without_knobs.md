Sometimes you need something for your component, like a custom UI-Model, oder an UI-Controller like a `ScrollController`, or `TabController` that is not or not yet implemented as a knob. Of course you could do that, but there is an easier approach that may fits your need just as well or even better.

We have implemented the `states addon` as a simple solution to offer generic state-handling for use cases. You can think of it as knobs, just without the knob; a headless knob.

This example demostrates how similar both approaches are. You can use the states addon to provide a `string`, just like you would with knobs. It will also be a ValueNotifier that you can get and set, just like with knobs. But it cannot be controlled with a control-component in the right panel.

```dart
WidgetBuilder statesUseCase(UseCaseComposer c) {
  final someStringKnob = c.knobs.string(
    'Some String',
    initialValue: 'Initial Value',
  );

  final someStringState = c.states.immutable(
    'Also Some String',
    initialValue: 'Initial Value',
  );

  return (context) {
    return Text(someStringState.value);
  } 
}
```

Now the advantage is that you can use this for anything

```dart
WidgetBuilder statesUseCase(UseCaseComposer c) {
  final someComponentState = c.states.immutable(
    'Some Component Model',
    initialValue: SomeComponentModel(
      ready: true,
      number: 24,
    ),
  );

  /// No knob for that.

  final textEditingControllerContainer = c.states.mutable(
    'TextEditingController',
    create: () => TextEditingController(text: 'Initial Text'),
    dispose: (controller) => controller.dispose(),
  );

  // Also no knob for that

  return (context) {
    /// ...
  };
}
```

Just like for knobs, when doing a hot reload, state is retained.


--- 

Now when you end up in a situation where there is no Knob for the thing you need you can implement a custom knob or use this feature.

# Info Dump

- c.states.immutable for immutables (especially useful for custom data classes like Component-Models)
- c.states.mutable for mutables ( TextEditingController, ScrollController, TabController, FocusNode)
- c.states.mutableWithTickerProvider for mutables with ticker (like TabController, AnimationController)

