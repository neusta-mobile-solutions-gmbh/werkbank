This topic provides an overview of techniques you can use to customize your use cases.
You can find more detailed information for some of the features in their respective topics.
We recommend reading [Getting Started](Getting%20Started-topic.html) and [File Structure](File%20Structure-topic.html) before this topic to
learn how to create basic use cases and how to structure them in your project.

**Table of Contents**
- [UseCaseComposer Basics](#usecasecomposer-basics)
- [Knobs](#knobs)
- [Constraints](#constraints)
- [Descriptions, Tags & URLs](#descriptions-tags--urls)
- [Background](#background)
- [State Keeping](#state-keeping)
- [Inheritance](#inheritance)
- [Wrapping](#wrapping)
- [Overview](#overview)
- [Notifications](#notifications)
- [Custom Composer Extensions](#custom-composer-extensions)
- [Advanced Composer Usage](#advanced-composer-usage)

## UseCaseComposer Basics

The [UseCaseComposer](../werkbank/UseCaseComposer-class.html) forms the core of customizing your use cases.
To define a use case, declare a [UseCaseBuilder](../werkbank/UseCaseBuilder.html) function that takes this composer as a parameter.

```dart
WidgetBuilder exampleUseCase(UseCaseComposer c) {
  // Use `c` here to customize the use case.

  return (context) {
    return ExampleWidget();
  };
}
```

All customizations with the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) are **optional**.
Your use case will work even when minimal, such as in the example above.
However, most customizations are worth the time to implement, since they
improve your development experience, make testing and design review easier,
and help you create better widgets.

The [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c` provides many functions and getters.
Use these functions in the use case before returning the
[WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html) to customize the use case.

> [!IMPORTANT]
> You cannot use the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
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

> [!TIP]
> You can apply customizations to multiple use cases at once by
> placing calls on the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
> in the [builder](../werkbank/WerkbankParentNode/builder.html) of parent nodes
> like [WerkbankRoot](../werkbank/WerkbankRoot-class.html),
> [WerkbankComponent](../werkbank/WerkbankComponent-class.html),
> or [WerkbankFolder](../werkbank/WerkbankFolder-class.html).
> These affect all the descendant use cases.
> Read more about this in the [Inheritance](#inheritance) section below.

[Addon](../werkbank/Addon-class.html)s introduce most methods and getters on the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) using extensions.
The respective addon must be active for these methods to work.
However, unless you have explicitly set `includeDefaultAddons: false` in your
[AddonConfig](../werkbank/AddonConfig-class.html), all these addons are included by default.
So **you do not need to do anything to enable the addons**.
Read more about default addons in the [Customizing The AppConfig](Customizing%20The%20AppConfig-topic.html) topic.

## Knobs

Knobs allow you to interactively control the values and parameters of your widget from within the Werkbank UI.
The [KnobsAddon](../werkbank/KnobsAddon-class.html) provides this functionality.

To create a knob in your use case, call `c.knobs.<knobType>` on the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c` and choose from one of the many
available knob types.
Store the returned [Knob](../werkbank/Knob-class.html) in a final variable to access from within the returned
[WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).

Read the knob value when building your widget using the [`knob.value`](../werkbank/Knob/value.html) getter.  
You can change the knob value in two ways:

- Interactively in the Werkbank UI.
  - Find the controls in the "CONFIGURE" tab under the "Knobs" section.
- Programmatically by using the [`knob.value = ...`](../werkbank/WritableKnob/value.html) setter.
  - Use this setter, for example, in `onChanged` callbacks.

This example shows a use case that uses a double slider knob to control the value of a slider:

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

**Knob presets** provide a way to quickly set the values of multiple knobs to predefined values.

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

Load a knob preset using the "Preset" dropdown in the "CONFIGURE" tab under the "Knobs" section.

> [!TIP]
> Beside the dropdown to load knob presets is a small button that opens an [Overview](Overview-topic.html) of all available presets.
> Use this feature to quickly find the preset you want to load in a visual way.
> You can also keep the overview open while developing your widget to see the effects of code changes in multiple states.

To learn more about knobs, read the [Knobs](Knobs-topic.html) topic.

## Constraints

The [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html) allows you to modify the
[BoxConstraints](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html)
passed to your use case, enabling you to test how your widget behaves under different size restrictions.

Flutter passes [BoxConstraints](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html)
to your widget during its layout phase.
Based on these constraints, your widget computes its layout and determines its own size.
Learn more about how Flutter's layout system works in their
["Understanding constraints"](https://docs.flutter.dev/ui/layout/constraints)
documentation.

You can set constraints in two ways:
- In the Werkbank UI by dragging the rulers, using shortcuts, or entering values in the text fields.
  - Learn more about this in the [Constraints](Constraints-topic.html) topic,
    or by viewing the shortcuts on the home page of your Werkbank by tapping the name or logo in the top left corner.
- Programmatically by defining initial constraints, constraints presets, overview constraints, and supported constraints
  using the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c` in your use case.

Even when setting constraints programmatically, you can always change them interactively in the Werkbank UI.

This example shows a use case that customizes the constraints of a slider widget:

```dart
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  // Set initial constraints for the use case.
  c.constraints.initial(width: 200);

  // Define constraints presets.
  c.constraints.preset('Narrow', width: 100);
  c.constraints.preset('Wide', width: 400);
  // Add predefined presets for common device sizes.
  // This is usually intended for use cases showcasing whole pages.
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

**Initial constraints** are the constraints applied to the use case when opened.
When not set, they default to loose [BoxConstraints](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html)
with a maximum width and height of the size of the main view.
Set this to a value that makes your widget look like it is in its "natural" or best-looking state.

**Constraints presets** are predefined sets of constraints that you can quickly apply to the use case.
Load presets using the "Preset" dropdown in the "CONFIGURE" tab under the "Constraints" section.
Adding presets is useful when your widget changes its appearance significantly depending on the constraints.
This way you can cover multiple layouts of your widget in one use case.
For pages, [`c.constraints.devicePresets()`](../werkbank/DevicePresetComposerExtension/devicePresets.html) provides a convenience method
that automatically adds presets for common device sizes.

**Overview constraints** are used for the [Overview](Overview-topic.html) thumbnails of the use case.
If not specified, they default to the initial constraints of the use case.
Set this to the smallest constraints that still make your widget look good.
Read on to the [Overview](#overview) section below,
or visit the [Overview](Overview-topic.html) topic for more information on how to customize the overview thumbnails.

The methods to define these types of constraints come in sets of three:

| ↓ Type \ Parameters → | `width` and `height`                                           | `Size`                                                                 | `BoxConstraints`                                                                     |
|-----------------------|----------------------------------------------------------------|------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| **Initial**           | [initial](../werkbank/ViewConstraintsExtension/initial.html)   | [initialSize](../werkbank/ViewConstraintsExtension/initialSize.html)   | [initialConstraints](../werkbank/ViewConstraintsExtension/initialConstraints.html)   |
| **Presets**           | [preset](../werkbank/ViewConstraintsExtension/preset.html)     | [presetSize](../werkbank/ViewConstraintsExtension/presetSize.html)     | [presetConstraints](../werkbank/ViewConstraintsExtension/presetConstraints.html)     |
| **Overview**          | [overview](../werkbank/ViewConstraintsExtension/overview.html) | [overviewSize](../werkbank/ViewConstraintsExtension/overviewSize.html) | [overviewConstraints](../werkbank/ViewConstraintsExtension/overviewConstraints.html) |

The three variants define the same constraints for a given type but use different parameters.
The following example shows how to use all three variants:
```dart
c.constraints.initial(width: 200, height: 100);
c.constraints.presetSize('Preset Name', const Size(400, 200));
c.constraints.overviewConstraints(const BoxConstraints(minWidth: 100, minHeight: 100));
```
Each of the nine methods also has optional `bool viewLimitedMaxWidth` and `bool viewLimitedMaxHeight` parameters.
They convert infinite ([`double.infinity`](https://api.flutter.dev/flutter/dart-core/double/infinity-constant.html))
maximum constraints to the size of the main view when `true` (the default).
This allows use cases to fill the available space in the Werkbank UI.
Set these to `false` if you want to use infinite maximum constraints instead.

**Supported constraints** limit the range of constraints that can be set for the use case.
For example, if you know that your widget will overflow when the width is less than 50 pixels,
you can use [`c.constraints.supported(const BoxConstraints(minWidth: 50))`](../werkbank/SupportedSizesComposerExtension/supported.html)
to prevent setting constraints smaller than that.

Learn more about constraints in the [Constraints](Constraints-topic.html) topic.

## Descriptions, Tags & URLs

The [DescriptionAddon](../werkbank/DescriptionAddon-class.html) allows you to add metadata about your use case
that displays in the "INSPECT" tab of the Werkbank UI.

```dart
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  // Add a description of your widget.
  c.description(
    'A *slider* that allows you to select a `value` from a range.\n'
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

**Description** is text that describes the use case in some way.
You can use it to:
- Explain the widget and its purpose.
- Provide context about where the widget should be used.
- Add any other information you want.

Markdown syntax is also supported.
To add a description, use the [`c.description('Description Text')`](../werkbank/DescriptionComposerExtension/description.html) method.

**Tags** are a list of strings that categorize your use case.
You can view the tags of a use case in the "INSPECT" tab.
In addition, the home page shows a list of all tags used in your project.
Clicking on a tag will paste `tag:"TAG_NAME"` into the search field,
filtering the use cases by that tag.
To add tags, use the [`c.tags(['TAG_1', 'TAG_2'])`](../werkbank/TagsComposerExtension/tags.html) method.

**URLs** are a list of strings that link to documentation, issues, or other resources related to the use case.
You can view the URLs in the "INSPECT" tab under the "External Links" section.
To add URLs, use the [`c.urls(['https://example.com'])`](../werkbank/UrlsComposerExtension/urls.html) method.

## Background

The [BackgroundAddon](../werkbank/BackgroundAddon-class.html) allows you to configure the backgrounds of your use cases.

You have two ways to set the backgrounds of use cases:
- In the code, define a default background for **individual use cases**.
- In the UI, override the background for **all use cases**.

This section covers only how to set the background in the code.
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
  // If you don't need the BuildContext, use `c.background.color(...)`.
  c.background.colorBuilder(
      (context) => Theme.of(context).colorScheme.surface,
  );

  // Set a widget as the background.
  // If you need a BuildContext, use `c.background.widgetBuilder(...)`.
  c.background.widget(
    Image.asset(
      'assets/background_image.jpg',
      fit: BoxFit.cover,
    ),
  );
  
  return (context) {
    return ExampleWidget(/* ... */);
  };
}
```

The [`c.background.named(...)`](../werkbank/BackgroundComposer/named.html) method refers to the name of one of the
[BackgroundOption](../werkbank/BackgroundOption-class.html)s defined in the [BackgroundAddon](../werkbank/BackgroundAddon-class.html).
By default, you can choose from the following options:
- `White` - Pure white background.
- `Black` - Pure black background.
- `None` - Transparent background that reveals the Werkbank UI color behind it.
- `Checkerboard` - A checkerboard pattern background. Useful for testing transparency.

You can also add custom named [BackgroundOption](../werkbank/BackgroundOption-class.html)s.
These also display as options in the UI.
Learn more about background options in the [Backgrounds](Backgrounds-topic.html) topic.

> [!TIP]
> To learn how to set the **default background for multiple use cases at once**,
> read the next section about [Inheritance](#inheritance).

> [!TIP]
> If you have a larger function call to set the background and plan on using it multiple times,
> consider extracting it into an extension on the [BackgroundComposer](../werkbank/BackgroundComposer-extension-type.html).
> Learn more about this in the [Custom Composer Extensions](#custom-composer-extensions) section below.
> Alternatively, add it as a custom [BackgroundOption](../werkbank/BackgroundOption-class.html)
> to the [BackgroundAddon](../werkbank/BackgroundAddon-class.html) and use
> [`c.background.named(...)`](../werkbank/BackgroundComposer/named.html).
> Learn more about that in the [Backgrounds](Backgrounds-topic.html) topic.

## State Keeping

The [StateKeepingAddon](../werkbank/StateKeepingAddon-class.html) allows you to keep state in your use cases
where you would normally need to wrap the use case widget in a
[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html).

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

The method [`c.states.immutable(...)`](../werkbank/StatesComposer/immutable.html)
provides you with a [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)
that holds an immutable value.
You can get and set the value in the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).

The method [`c.states.mutable(...)`](../werkbank/StatesComposer/mutable.html)
returns a [ValueContainer](../werkbank/ValueContainer-class.html) that holds a mutable value.
You can unpack the value in the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
using the [value](../werkbank/ValueContainer/value.html) getter.
Unlike with immutable state, you cannot change the value of the [ValueContainer](../werkbank/ValueContainer-class.html)
though.

> [!TIP]
> Most knobs also keep immutable state, similar to [`c.states.immutable(...)`](../werkbank/StatesComposer/immutable.html).
> If having a way control the state from the Werkbank UI is beneficial in your case,
> consider using a knob instead.

Learn more about state keeping in the [Keeping State](Keeping%20State-topic.html) topic.

## Inheritance

Similar to [WerkbankUseCase](../werkbank/WerkbankUseCase-class.html)s,
parent nodes of the use case tree have an optional
[builder](../werkbank/WerkbankParentNode/builder.html).
The builder allows you to configure all the use cases in the respective parent node using a
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`.

The parent nodes are:
- [WerkbankRoot](../werkbank/WerkbankRoot-class.html) - The root of the use case tree.
- [WerkbankComponent](../werkbank/WerkbankComponent-class.html) - A node intended to group multiple
  use cases that display the same component/widget.
- [WerkbankFolder](../werkbank/WerkbankFolder-class.html) - A folder grouping multiple use cases, components, or other folders.

This example shows how to use the [builder](../werkbank/WerkbankParentNode/builder.html)s
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

Depending on the method, the configuration may be either overridden or merged in some way.
The respective methods document this behavior.
If you want the calls in the parents to be merged after the configuration of their children,
you can use [`c.addLateExecutionCallback(() { ... })`](../werkbank/UseCaseComposer/addLateExecutionCallback.html)
to call the methods after the methods of the children have been executed.

## Wrapping

The [WrappingAddon](../werkbank/WrappingAddon-class.html) allows you to wrap your use case widget
using the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`.

This feature is most useful when combined with the [Inheritance](#inheritance) feature described above.
That way you can wrap all use cases in a parent node with a common widget.
The wrapping feature also allows you to use knobs from within the [builder](../werkbank/WerkbankParentNode/builder.html)s
of the parent nodes.

This example adds a knob to all page use cases that controls the padding
used by [SafeArea](https://api.flutter.dev/flutter/widgets/SafeArea-class.html)s:
```dart
WerkbankRoot get root => WerkbankRoot(
  children: [
    /* ... */
    WerkbankFolder(
      name: 'Pages',
      builder: (c) {
        // Create a slider knob to control the safe area.
        final safeAreaKnob = c.knobs.doubleSlider(
          'Safe Area',
          max: 250,
          initialValue: 0,
        );

        // Wrap use cases in a MediaQuery that sets the padding used by the SafeArea widget.
        c.wrapUseCase(
          (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: EdgeInsets.all(safeAreaKnob.value),
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
You can access it, for example, by tapping a folder or component in the navigation tree or via the "Overview" button above the tree.

If you have already added some use cases to your project, you may have noticed that the thumbnails do not always represent your widget well by default.
Ideally, the thumbnail should display the widget differently depending on how big it is, whether it fills the whole screen, or other factors.
But Werkbank cannot know these things about the use case unless you tell it.
If you do not, you may get problems like:
- Widgets that are too small to see
- Large widgets crammed into a small space
- Overflows in the thumbnail
- Widgets with much more content than you would need for a minimal example

These examples show how to customize the overview thumbnails of your use cases:
```dart
WidgetBuilder myPageUseCase(UseCaseComposer c) {
  // Set the minimum size that the thumbnail should give the widget.
  // If the thumbnail is smaller, it will scale the widget down to fit.
  c.overview.minimumSize(height: 400);
  // Remove the padding that the thumbnail adds around the widget.
  c.overview.withoutPadding();
  
  return (context) {
    return MyPage(
      // Change the widget depending on if used as thumbnail.
      // You could swap it out completely for a custom thumbnail too.
      hasALotOfContent: !UseCase.isInOverviewOf(context)
    );
  };
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

For a more detailed guide on how to optimize your use case thumbnails and the overview feature in general,
visit the [Overview](Overview-topic.html) topic.

## Notifications

Sometimes widgets in your use case expect callbacks like `onPressed` or `onTap`.
If you want to make sure that these callbacks are called correctly, you can dispatch a notification
to the Werkbank UI:

```dart
WidgetBuilder elevatedButtonUseCase(UseCaseComposer c) {
  return (context) {
    return ElevatedButton(
      onPressed: () {
        // Dispatch a notification when the button is pressed.
        UseCase.dispatchTextNotification(context, 'onPressed');
      },
      child: const Text('Press Me'),
    );
  };
}
```

Use [`UseCase.dispatchTextNotification(...)`](../werkbank/UseCase/dispatchTextNotification.html) to send a simple
[String](https://api.flutter.dev/flutter/dart-core/String-class.html) as notification.
You can also dispatch more elaborate notifications using
[`UseCase.dispatchNotification(...)`](../werkbank/UseCase/dispatchNotification.html) and a
[WerkbankNotification](../werkbank/WerkbankNotification-class.html) object.

## Custom Composer Extensions

Sometimes you may end up repeating the same or similar calls to the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) `c`
in multiple use cases.
To prevent this code duplication, first check if the calls can be moved to a parent node using the
[Inheritance](#inheritance) feature described above.
If that is not possible, we recommend extracting the calls into an extension on the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) or one of the more specific composers:
- `c.knobs` ([KnobsComposer](../werkbank/KnobsComposer-extension-type.html))
- `c.constraints` ([ViewConstraintsComposer](../werkbank/ViewConstraintsComposer-extension-type.html))
- `c.background` ([BackgroundComposer](../werkbank/BackgroundComposer-extension-type.html))
- `c.overview` ([OverviewComposer](../werkbank/OverviewComposer-extension-type.html))

These two examples show how this could look:
```dart
// An extension used on `c`, adding a knob to control safe areas.
extension SafeAreaComposerExtension on UseCaseComposer {
  void withSafeArea() {
    final safeAreaKnob = knobs.doubleSlider(
      'Safe Area',
      max: 250,
      initialValue: 0,
    );

    wrapUseCase(
        (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: EdgeInsets.all(safeAreaKnob.value),
          ),
          child: child,
        );
      },
    );
  }
}

// An extension on `c.background`, adding a method to set
// the surface color as background.
extension SurfaceBackgroundComposerExtension on BackgroundComposer {
  void surface() {
    colorBuilder(
      (context) => Theme.of(context).colorScheme.surface,
    );
  }
}
```

Use these extensions in your use cases like this:
```dart
WidgetBuilder listTileUseCase(UseCaseComposer c) {
  // Add knob for safe area, since ListTiles use safe areas internally.
  c.withSafeArea();

  // Use the surface background.
  c.background.surface();

  return (context) => ListTile(/* ... */);
}
```

## Advanced Composer Usage

You can use the [UseCaseComposer](../werkbank/UseCaseComposer-class.html) in many more ways than are covered in this topic.
Some of the more advanced uses include:
- Store your own information about a use case by using custom metadata.
  - Learn more about this in the
    [Custom Use Case Metadata](Custom%20Use%20Case%20Metadata-topic.html) topic.
- Write an [Addon](../werkbank/Addon-class.html) that adds custom functionality to the
  [UseCaseComposer](../werkbank/UseCaseComposer-class.html).
  - Learn more about this in the [Writing Your Own Addons](Writing%20Your%20Own%20Addons-topic.html) topic.
- Write custom knobs that integrate into the [KnobsAddon](../werkbank/KnobsAddon-class.html).
  - Learn more about this in the [Knobs](Knobs-topic.html) topic.
- Add keywords or texts to the use case that are searched when filtering the use cases.
  - Learn more about this in the [Search](Search-topic.html) topic.

> [!TIP]
> Autocomplete the `c.` in your IDE to see all available methods and getters on the
> [UseCaseComposer](../werkbank/UseCaseComposer-class.html).
> You may find some more useful things that are not covered in this topic.
