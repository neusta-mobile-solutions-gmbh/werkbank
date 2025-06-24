> [!CAUTION]
> This topic is under construction.

In [Get Started](Get%20Started-topic.html) and [File Structure](File%20Structure-topic.html)
you have learned how to create basic use cases and how to structure them in your project.
In this topic we will explore the many ways to customize your use cases and how to
get the most out of Werkbank.

At the core of customizing your use cases is the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) which is passed to the
[UseCaseBuilder](../werkbank/UseCaseBuilder-class.html) function.

There are many functions and getters defined on the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
which can be used in the use case before returning the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
in order to customize the use case.

> [!IMPORTANT]
> You can't use the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
> from within the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html):
> 
> ```dart
> WidgetBuilder wrongUseCase(UseCaseComposer c) {
> ​  return (context) {
> ​    // This is not allowed here! Must be above the return statement.
> ​    c.description('Example description.');
> ​    return ExampleWidget();
> ​  };
> }
> ```

## Knobs

Knobs are a powerful way to interactively change the properties of your widget in the Werkbank UI.
However unlike in Widgetbook the values of knobs can also be modified by the widget allowing you to
have your widget usable as it would be in your app and control it from the Werkbank UI at the same time.

To create a knob in your use case, call `c.knobs.<knobType>` on the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c` and choose from one of the many
available knob types.

Here is an example of a use case that uses a double slider knob to control the value of a slider:
```dart
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  final valueKnob = c.knobs.doubleSlider(
    'Value',
    initialValue: 0.5,
  );
  
  return (context) {
    return Slider(
      value: valueKnob.value,
      onChanged: (value) => valueKnob.value = value,
    );
  };
}
```

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

## Constraints

## Descriptions, Tags & URLs

## Background

## Inheritance

## Wrapping

## Custom Composer calls
