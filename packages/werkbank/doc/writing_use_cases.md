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

Most of the methods and getters on the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
are introduced by [Addon](../werkbank/Addons-topic.html)s.
For them to work, the respective addon must be active.
However, unless you have explicitly set `includeDefaultAddons: false` in your
[AddonConfig](../werkbank/AddonConfig-class.html), all these addons are included by default.
So **you don't need to do anything to enable the addons**.
Read more about default addons in the [Customizing The AppConfig](Customizing%20The%20AppConfig-topic.html) topic.

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
Read on to the [Overview](#overview) section below
or visit the [Overview](Overview-topic.html) topic for more information on how to customize the overview thumbnails.

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
  c.tags(['INPUT', 'SLIDER']);
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

You have two ways to set the backgrounds of use cases:
- In the Code, define a default background for **individual use cases**.
- In the UI, override the background for **all use cases**.

Here, we only cover how to set the background in the code.
To learn how to configure the backgrounds in the Werkbank UI,
visit the [Backgrounds](Backgrounds-topic.html) topic.

Set the default background for a use case using one of the methods on
[`c.background`](../werkbank/BackgroundComposerExtension/background.html):
```dart
WidgetBuilder exampleUseCase(UseCaseComposer c) {
  // SETTING BACKGROUND MULTIPLE TIMES IS JUST FOR THE DEMO.
  // Later calls override previous ones.
  
  // Set the background to one of the named BackgroundOptions.
  // Some are included by default. Add custom ones in the BackgroundAddon.
  c.background.named('Checkerboard');
  
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
      (context) => Theme.of(context).colorScheme.surface,
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
    return ExampleWidget(/* ... */);
  };
}
```

The [`c.background.named(...)`](../werkbank/BackgroundComposer/named.html) method refers to the name of one of the
[BackgroundOption](../werkbank/BackgroundOption-class.html)s defined in the [BackgroundAddon](../werkbank/BackgroundAddon-class.html).
By default you can choose one of the following options:
- `White` - Pure white background.
- `Black` - Pure black background.
- `None` - Transparent background, which reveals the Werkbank UI color behind it.
- `Checkerboard` - A checkerboard pattern background. Useful for testing transparency.

You can also add custom named [BackgroundOption](../werkbank/BackgroundOption-class.html)s.
Learn more about that in the [Backgrounds](Backgrounds-topic.html) topic.

The other methods shown in the example allow you to set the background to a [Color](https://api.flutter.dev/flutter/dart-ui/Color-class.html),
or a [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html).
They each have two variants:
- [`c.background.color(...)`](../werkbank/BackgroundComposerExtension/color.html) and
  [`c.background.widget(...)`](../werkbank/BackgroundComposerExtension/widget.html)
  accept a [Color](https://api.flutter.dev/flutter/dart-ui/Color-class.html) or a [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html)
  directly.
- [`c.background.colorBuilder(...)`](../werkbank/BackgroundComposerExtension/colorBuilder.html) and
  [`c.background.widgetBuilder(...)`](../werkbank/BackgroundComposerExtension/widgetBuilder.html)
  accept a builder function that provides a [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html),
  which allows you to access for example the current theme.

> [!TIP]
> To learn how to set the **default background for multiple use cases at once**,
> read the next section about [Inheritance](#inheritance).

> [!TIP]
> If you have a larger function call to set the background, and plan on using it multiple times,
> consider extracting it into an extension on the [BackgroundComposer](../werkbank/BackgroundComposer-class.html).
> Learn more about this in the [Custom Composer calls](#custom-composer-calls) section below.
> Alternatively, add it as a custom [BackgroundOption](../werkbank/BackgroundOption-class.html)
> to the [BackgroundAddon](../werkbank/BackgroundAddon-class.html) and use
> [`c.background.named(...)`](../werkbank/BackgroundComposer/named.html).
> Learn more about that in the [Backgrounds](Backgrounds-topic.html) topic.

## Inheritance

Similar to [WerkbankUseCase](../werkbank/WerkbankUseCase-class.html)s,
parent nodes of the use case tree have an optional
[builder](../werkbank/WerkbankParentNode/builder.html).
It allows you to configure all the use cases in the respective parent node using a
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`.

The parent nodes are:
- [WerkbankRoot](../werkbank/WerkbankRoot-class.html) - The root of the use case tree.
- [WerkbankComponent](../werkbank/WerkbankComponent-class.html) - A node intended to group multiple
  use cases that display the same component/widget.
- [WerkbankFolder](../werkbank/WerkbankFolder-class.html) - A folder grouping multiple use cases, components, or other folders.

Here is an example of how to use the [builder](../werkbank/WerkbankParentNode/builder.html)s
on the parent nodes to configure multiple use cases at once:
```dart
WerkbankRoot get root => WerkbankRoot(
  builder: (c) {
    // Set the default background for all use cases.
    // (The "Pages" folder overrides this.)
    c.background.colorBuilder(
        (context) => Theme.of(context).colorScheme.surface,
    );
  },
  children: [
    WerkbankFolder(
      name: 'Components',
      builder: (c) {
        // Add "COMPONENT" tag to all components.
        c.tags(['COMPONENT']);
      },
      children: [/* ... use cases ... */],
    ),
    WerkbankFolder(
      name: 'Pages',
      builder: (c) {
        // Add device constraints presets for all pages.
        c.constraints.devicePresets();
        // Add a simple description to all pages.
        c.description('A page.');
        // Override the default background for all pages,
        // so that we can easily see the edges when zooming out.
        c.background.named('Checkerboard');
      },
      children: [/* ... use cases ... */],
    ),
    /* ... */
  ],
);
```

Using the [builder](../werkbank/WerkbankParentNode/builder.html)s on parent nodes
allows you to avoid code duplication in your use cases.
Even when a few use cases need a different configuration,
you can still define the common configuration in the parent node
and modify it in the use case or nested parent nodes by calling the
same methods again.

Depending in the method, the configuration may be either overridden or merged in some way.
The respective methods document this behavior.

## Wrapping

The [WrappingAddon](../werkbank/WrappingAddon-class.html) allows you to wrap your use case widget
using the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`.

This ist mostly useful when combined with the [Inheritance](#inheritance) feature described above.
That way you can wrap all use cases in a parent node with a common widget.
It also allows you to use knobs from within the [builder](../werkbank/WerkbankParentNode/builder.html)s
of the parent nodes.

This example adds two knobs to all page use cases, which control the horizontal and vertical safe area.
```dart
WerkbankRoot get root => WerkbankRoot(
  children: [
    /* ... */
    WerkbankFolder(
      name: 'Pages',
      builder: (c) {
        final horizontalSafeAreaKnob = c.knobs.doubleSlider(
          'Horizontal Safe Area',
          max: 250,
          initialValue: 0,
        );

        final verticalSafeAreaKnob = c.knobs.doubleSlider(
          'Vertical Safe Area',
          max: 250,
          initialValue: 0,
        );

        c.wrapUseCase(
          (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding:
                MediaQuery.paddingOf(context) +
                  EdgeInsets.symmetric(
                    horizontal: horizontalSafeAreaKnob.value,
                    vertical: verticalSafeAreaKnob.value,
                  ),
              ),
              child: child,
            );
          },
        );
      },
      children: [/* ... use cases ... */],
    ),
  ],
);
```

## Overview

The overview is a screen that displays preview thumbnails of use cases in a grid layout.
You can access it for example by tapping a folder or component in the navigation tree or via the "Overview" button above the tree.

If you have already added some use cases to your project, you may have noticed that the thumbnails don't always represent your widget well by default.
Ideally, the thumbnail should display the widget differently depending on how big it is, whether it fills the whole screen, or other factors.
But Werkbank can't know these things about the use case unless you tell it.
If you don't, you may get problems like:
- Widgets that are too small to see
- Large widgets crammed into a small space
- Overflows in the thumbnail
- Widgets with much more content that you would need for a minimal example

Here some examples of how to customize the overview thumbnails of your use cases:
```dart
WidgetBuilder myPageUseCase(UseCaseComposer c) {
  // Set the minimum size that the thumbnail should give the widget.
  // If the thumbnail is smaller, it will scale the widget down to fit.
  c.overview.minimumSize(height: 400);
  // Remove the padding that the thumbnail adds around the widget.
  c.overview.withoutPadding();
  
  return (context) => MyPage();
}

WidgetBuilder myTinyWidgetUseCase(UseCaseComposer c) {
  // Set the constraints used in the thumbnail.
  c.constraints.overview(width: 40);
  // Set the minimum size that the thumbnail should give the widget.
  // If the thumbnail is smaller, it will scale the widget down to fit.
  c.overview.minimumSize(width: 50, height: 50);
  // Allow the thumbnail to scale the widget up.
  c.overview.maximumScale(3.0);

  return (context) => MyTinyWidget();
}
```

For a more detailed guide on how to optimize your use case thumbnails, and the overview feature in general,
visit the [Overview](Overview-topic.html) topic.

## Custom Composer calls

## Advanced Composer Usage
