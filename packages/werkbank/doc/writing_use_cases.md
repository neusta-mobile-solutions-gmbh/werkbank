> [!CAUTION]
> This topic is under construction.

This topic gives an overview of the techniques that can be used to customize your use cases.
You can find more detailed information for some of the features in their respective topics.
We recommended reading [Get Started](Get%20Started-topic.html) and [File Structure](File%20Structure-topic.html) before this topic to
learn how to create basic use cases and how to structure them in your project.

## UseCaseComposer Basics

At the core of customizing your use cases is the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) which is passed to the
[UseCaseBuilder](../werkbank/UseCaseBuilder.html) function.

```dart
WidgetBuilder exampleUseCase(UseCaseComposer c) {
  // Use `c` here to customize the use case.

  return (context) {
    return ExampleWidget();
  };
}
```

All customizations with the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) are **optional**.
Your use case will work even if minimal, such as in the example above.
However, most are worth the time and effort to implement, since they
improve your development experience, make testing and design review easier,
or help to impress your customers.

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
  // Create a double slider knob to control the value of the slider.
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

  // Define a knob preset to quickly set the values of the knobs.
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

The [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html) allows you to modify the
[`BoxConstraints`](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html)
passed to your use case, enabling you to test how your widget behaves under different size restrictions.

Flutter passes [`BoxConstraints`](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html)
to your widget during its layout phase.
Based on these, your widget layouts itself and determines own size.
Learn more about how Flutter's layout system works in their
["Understanding constraints"](https://docs.flutter.dev/ui/layout/constraints)
documentation.

You can set constraints in two ways:
- In the Werkbank UI by dragging the rulers, using shortcuts, or entering values in the text fields.
  - Learn more about this in the [Constraints](Constraints-topic.html) topic
    or by viewing the shortcuts in the home page of your Werkbank by tapping the name or logo in the top left corner.
- Programmatically, by defining initial constraints, constraints presets, overview constraints, and supported constraints
  using the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c` in your use case.

Even when setting constraints programmatically, you can always change them interactively in the Werkbank UI.

Here is an example of a use case that customizes the constraints of a slider widget:

```dart
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  // Set initial constraints for the use case.
  c.constraints.initial(width: 200);

  // Define constraints presets.
  c.constraints.preset('Narrow', width: 100);
  c.constraints.preset('Wide', width: 400);
  // Add predefined presets for common device sizes for use cases showcasing whole pages.
  // (Technically wrong here, since a slider is not a page.)
  c.constraints.devicePresets();

  // Set constraints for overview thumbnails.
  c.constraints.overview(width: 100);

  // Limit the range of constraints that can be set.
  c.constraints.supported(const BoxConstraints(minWidth: 50));

  return (context) {
    return Slider(/* ... */);
  };
}
```

**Initial constraints** are the constraints applied to the use case when it is opened.
When not set, they default to loose [BoxConstraints](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html)
with a maximum width and height of the size of the main view.
Set this to a value that makes your widget look like it's in its "natural" or best looking state.

**Constraints presets** are predefined sets of constraints that you can quickly apply to the use case.
Load presets using the "Preset" dropdown in the "CONFIGURE" tab under the "Constraints" section.
Adding presets is useful when your widget changes its appearance significantly depending on the constraints.
This way you can cover for example multiple layouts of your widget in one use case.
For pages there is also the convenience method [`c.constraints.devicePresets()`](../werkbank/DevicePresetComposerExtension/devicePresets.html)
which automatically adds presets for common device sizes.

**Overview constraints** are used for the [Overview](Overview-topic.html) thumbnails of the use case.
If not specified, they default to the initial constraints of the use case.
Set this to the smallest constraints that still make your widget look good.
Visit the [Overview](Overview-topic.html) topic for more information on how to customize the overview thumbnails.

The methods to define these types of constraints come in sets of three:

| Parameters → | `width` and `height`                                           | `Size`                                                                 | `BoxConstraints`                                                                     |
|--------------|----------------------------------------------------------------|------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Initial      | [initial](../werkbank/ViewConstraintsExtension/initial.html)   | [initialSize](../werkbank/ViewConstraintsExtension/initialSize.html)   | [initialConstraints](../werkbank/ViewConstraintsExtension/initialConstraints.html)   |
| Presets      | [preset](../werkbank/ViewConstraintsExtension/preset.html)     | [presetSize](../werkbank/ViewConstraintsExtension/presetSize.html)     | [presetConstraints](../werkbank/ViewConstraintsExtension/presetConstraints.html)     |
| Overview     | [overview](../werkbank/ViewConstraintsExtension/overview.html) | [overviewSize](../werkbank/ViewConstraintsExtension/overviewSize.html) | [overviewConstraints](../werkbank/ViewConstraintsExtension/overviewConstraints.html) |

The three variants define the same constraints but using different parameters.
For example:
```dart
c.constraints.initial(width: 200, height: 100);
c.constraints.presetSize('Preset Name', const Size(400, 200));
c.constraints.overviewConstraints(const BoxConstraints(minWidth: 100, minHeight: 100));
```
Each of the nine methods also has optional `bool viewLimitedMaxWidth` and `bool viewLimitedMaxHeight` parameters.
They convert infinite maximum constraints to the size of the main view when `true` (the default).
This allows use cases to fill the available space in the Werkbank UI.
Set these to `false` if you want to use infinite maximum constraints instead.

The **supported constraints** limit the range of constraints that can be set for the use case.
For example if you know that your widget will overflow when the width is less than 50 pixels,
you can use [`c.constraints.supported(const BoxConstraints(minWidth: 50))`](../werkbank/SupportedSizesComposerExtension/supported.html)
to prevent setting constraints smaller than that.

Learn more about constraints in the [Constraints](Constraints-topic.html) topic.

## Descriptions, Tags & URLs

The [DescriptionAddon](../werkbank/DescriptionAddon-class.html) allows you to add metadata about your use case
that is displayed in the "INSPECT" tab of the Werkbank UI.

```dart
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  // Add a description of your widget.
  c.description(
    'A *slider* that allows to select a `value` from a range.\n'
      'You can even use **Markdown** syntax here!',
  );
  // Add tags to categorize your use case.
  c.tags(['input', 'slider']);
  // Add URLs to link to documentation or other resources.
  c.urls([
    'https://api.flutter.dev/flutter/material/Slider-class.html',
    'https://m3.material.io/components/sliders',
  ]);

  return (context) {
    return Slider(/* ... */);
  };
}
```

The **description** is a text that describes the use case is some way.
You can use it to:
- Explain the widget and its purpose.
- Provide context about where the widget should be used.
- Or anything else you want.

Markdown syntax is also supported.
To add a description, use the [`c.description('Description Text')`](../werkbank/DescriptionComposerExtension/description.html) method.

The **tags** are a list of strings that categorize your use case.
You can view the tags of a use case in the "INSPECT" tab.
In addition, the home page shows a list of all tags used in your project.
Clicking on a tag will paste `tag:"TAG_NAME"` into the search field,
filtering the use cases by that tag.
To add tags, use the [`c.tags(['tag1', 'tag2'])`](../werkbank/TagsComposerExtension/tags.html) method.

The **URLs** are a list of strings that link to documentation, issues or other resources related to the use case.
You can view the URLs in the "INSPECT" tab under the "External Links" section.
To add URLs, use the [`c.urls(['https://example.com'])`](../werkbank/UrlsComposerExtension/urls.html) method.

## Background

The [BackgroundAddon](../werkbank/BackgroundAddon-class.html) allows you to configure the backgrounds of your use cases.

There are two ways to change the background of use cases:
- Set the **default background of a use case** using one of the methods on [`c.background`](../werkbank/BackgroundComposerExtension/background.html).
  - Each use case can have a different default background.
- Set the background for **all use cases** by choosing from a dropdown in the "SETTINGS" tab under the "Background" section.
  - The "Use Case Default" is one of those options.
  - The backgrounds "White", "Black", "None", and "Checkerboard" are included by default.
  - New selectable [BackgroundOption](../werkbank/BackgroundOption-class.html)s can be added in the [AddonConfig](../werkbank/AddonConfig-class.html).

Like most other addons, the [BackgroundAddon](../werkbank/BackgroundAddon-class.html) is enabled by default.
But if you want add additional background options, you need to add
the [BackgroundAddon](../werkbank/BackgroundAddon-class.html) to your
[AddonConfig](../werkbank/AddonConfig-class.html) to overwrite the one added by default.

```dart
AddonConfig get addonConftig => AddonConfig(
  addons: [
    /* ... */
    // If you don't need to add additional background options,
    // you can omit the BackgroundAddon, since it is enabled by default.
    BackgroundAddon(
      backgroundOptions: [
        // Add a custom background option.
        BackgroundOption.colorBuilder(
          name: 'Surface',
          colorBuilder: (context) => Theme.of(context).colorScheme.surface,
        ),
      ],
    ),
  ],
);
```

> [!TIP]
> Read the next section about [Inheritance](#inheritance) to learn how to
> set the default background for multiple use cases at once.

```dart
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  // SETTING BACKGROUND MULTIPLE TIMES IS JUST FOR THE DEMO.
  // Later calls overwrite previous ones.
  
  // Set the background of the use case to a named color.
  c.background.named('Surface');
  
  // Set the background to a color.
  c.background.color(Colors.white);

  // Set a widget as the background.
  c.background.widget(
    Image.asset(
      'assets/background_image.jpg',
      fit: BoxFit.cover,
    ),
  );
  
  // Set the background to a color with a BuildContext.
  c.background.colorBuilder(
      (context) => Theme.of(context).colorScheme.surfaceContainer,
  );

  // Set the background to a widget using a WidgetBuilder.
  c.background.widgetBuilder((context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
      ),
    );
  });
  
  return (context) {
    return Slider(/* ... */);
  };
}
```

## Inheritance

## Wrapping

## Overview

## Custom Composer calls
