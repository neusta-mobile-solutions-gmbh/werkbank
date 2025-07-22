> [!CAUTION]
> This topic is under construction.

This topic gives an overview of the techniques that can be used to customize your use cases.
You can find more detailed information for some of the features in their respective topics.
We recommended reading [Get Started](Get%20Started-topic.html) and [File Structure](File%20Structure-topic.html) before this topic to
learn how to create basic use cases and how to structure them in your project.


## UseCaseComposer Basics

At the core of customizing your use cases is the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) which is passed to the
[UseCaseBuilder](../werkbank/UseCaseBuilder-class.html) function.

```dart
WidgetBuilder exampleUseCase(UseCaseComposer c) {
  // Use `c` here to customize the use case.
  
  return (context) {
    return ExampleWidget();
  };
}
```

There are many functions and getters defined on the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`.
They can be used in the use case before returning the
[WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html) to customize the use case.

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

## Constraints

## Descriptions, Tags & URLs

## Background

## Inheritance

## Wrapping

## Custom Composer calls
