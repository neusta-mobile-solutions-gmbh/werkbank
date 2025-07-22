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
Knobs allow you to interactively control the values and parameters of your widget from within the Werkbank UI.
They are provided by the [KnobsAddon](../werkbank/KnobsAddon-class.html).
You don't need to do anything to enable the addon unless you have explicitly excluded it in your
[AddonConfig](../werkbank/AddonConfig-class.html).

To create a knob in your use case, call `c.knobs.<knobType>` on the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c` and choose from one of the many
available knob types.
Store the returned [Knob](../werkbank/Knob-class.html) in a final variable to access from within the returned
[WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).

Read the knob value when building your widget using the [`knob.value`](../werkbank/Knob/value.html) getter.  
You can change the knob value in two ways:
- Interactively, in the Werkbank UI.
  - You can find the controls in the "CONFIGURE" tab under the "Knobs" section.
- Programmatically, by using the [`knob.value = ...`](../werkbank/WritableKnob/value.html) setter.
  - Use this for example in `onChanged` callbacks.

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

### Knob Presets
Knob presets are a way to quickly set the values of multiple knobs to predefined values.

Define knob presets using the [`c.knobPreset(...)`](../werkbank/KnobsComposerExtension/knobPreset.html) method
and provide a label and a callback that sets the desired knob values:
```dart
WidgetBuilder filledButtonUseCase(UseCaseComposer c) {
  final enabledKnob = c.knobs.boolean('Enabled', initialValue: true);
  final labelKnob = c.knobs.string('Label', initialValue: 'Label Text');
  
  c.knobPreset('Disabled & Long Label', () {
    enabledKnob.value = false;
    labelKnob.value = 'This is a long label text';
  });
  
  return (context) {
    return FilledButton(
      onPressed: enabledKnob.value ? () {} : null,
      child: Text(labelKnob.value),
    );
  };
}
```

Load a knob preset using the "Preset" dropdown above the knobs controls in the Werkbank UI.
You can find both in the "CONFIGURE" tab under the "Knobs" section.

> [!TIP]
> Beside the dropdown to load knob presets is a small button to open an [Overview](Overview-topic.html) of all available presets.
> Use this to quickly find the preset you want to load in a visual way.
> You can also keep the overview open while developing your widget to see the effects of code changes in multiple states.

To learn more about knobs, read the [Knobs](Knobs-topic.html) topic.

## Constraints

## Descriptions, Tags & URLs

## Background

## Inheritance

## Wrapping

## Overview

## Custom Composer calls
