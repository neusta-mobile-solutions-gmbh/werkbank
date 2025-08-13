The overview is a screen that displays preview thumbnails of use cases in a grid layout,
allowing you to quickly navigate through your use cases by their visual appearance.
This may be easier than finding their name in the tree structure in the left navigation panel.

The overview can be accessed in several ways:
- From the "Overview" button below the search bar in the left navigation panel
- By clicking on a folder or component in the navigation tree in the left panel
- If you are using the [KnobsAddon](../werkbank/KnobsAddon-class.html),
  by clicking on the overview button to the left of the knob preset selection dropdown
  in the "CONFIGURE" tab of the right configuration panel.
  - This will show an overview not of multiple use cases, but of the **knob presets**
    defined for the current use case.
    This can be very useful to see the effects of code changes
    on multiple states of the widget at the same time.

When viewing an overview of a folder, component, or all use cases,
the shown use cases are filtered by the search, just like the navigation tree.

> [!TIP]
> You can also use the [ViewerAddon](../werkbank/ViewerAddon-class.html) within the overview to zoom or pan the thumbnails.

## Optimizing Thumbnails

The thumbnails are shown by actually building the widgets from the use case.
So they are *not* just static images generated from the use case.

However, this means that the widgets built by the use case will be
**forced to fit** into the size of the thumbnail.
This may be a problem if the widget cannot handle the small constraints, leading to **overflows**,
or it may simply not look representative of what the widget would look like in a real app.
The opposite could also be the case, where a small widget is barely visible in the thumbnail.

**Luckily, there are several ways to customize the size and appearance of the thumbnails.**

> [!TIP]
> If you are just looking for a **quick and dirty** way to prevent your use cases from overflowing in the thumbnail,
> you can add the following to the
> [`builder`](../werkbank/WerkbankParentNode/builder.html)
> of your
> [WerkbankRoot](../werkbank/WerkbankRoot-class.html):
> ```dart
> WerkbankRoot(
> ​  builder: (c) {
> ​    // This is a "hack".
> ​    c.overview.minimumSize(width: 500, height: 500);
> ​  },
> ​  children: [...],
> )
> ```
> 
> However, for better results and to understand what's going on, you should continue reading.

> [!IMPORTANT]
> Just like in the tip above,
> all of the following method calls on the [UseCaseComposer `c`](../werkbank/UseCaseComposer-class.html)
> can be made inside the builder of a
> [WerkbankRoot](../werkbank/WerkbankRoot-class.html),
> [WerkbankFolder](../werkbank/WerkbankFolder-class.html), or
> [WerkbankComponent](../werkbank/WerkbankComponent-class.html)
> in order to apply to all use cases within.
> 
> See [Structure and Overview](Structure-topic.html) for more documentation on that.

### Adjusting the Constraints

By default, the widget built inside the thumbnail will be given the same
[BoxConstraints](https://api.flutter.dev/flutter/rendering/BoxConstraints-class.html) as if
it were displayed in the main view if the main view would be the size of the thumbnail.

When *not* using the [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html),
these constraints have a min of 0 and infinite max on both axes (so `BoxConstraints()`).
Without the [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html), you cannot customize
the constraints used in the thumbnail, nor in the main view for that matter.
You should really consider using the [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html)
or at least another third-party or custom addon that allows you to set constraints.

When using the [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html),
these constraints default to the constraints set by
[`c.constraints.initial(...)`](../werkbank/ViewConstraintsExtension/initial.html),
[`c.constraints.initialConstraints(...)`](../werkbank/ViewConstraintsExtension/initialConstraints.html), or
[`c.constraints.initialSize(...)`](../werkbank/ViewConstraintsExtension/initialSize.html)
in the use case.
If none of them is set, the constraints default to having
a minimum of 0 and a maximum of the size of the view on both axes.

To use different constraints in the overview than the initial constraints,
you can customize them using
[`c.constraints.overview(...)`](../werkbank/ViewConstraintsExtension/overview.html),
[`c.constraints.overviewConstraints(...)`](../werkbank/ViewConstraintsExtension/overviewConstraints.html), or
[`c.constraints.overviewSize(...)`](../werkbank/ViewConstraintsExtension/overviewSize.html).
These methods work the same as the `initial` methods but only apply to the overview.

This could look like this:
```dart
WidgetBuilder exampleUseCase(UseCaseComposer c) {
  c.constraints.overview(width: 200);
  
  return (context) => ExampleWidget();
}
```

### Adjusting the Scale

If the constraints are bigger than the thumbnail (ignoring some padding covered later),
the use case will simply draw outside the bounds of the thumbnail without causing an overflow.

However, for larger widgets, we may want to scale them down so that their constraints
and therefore also their size fit inside the bounds of the thumbnail.
Inversely, we may want to scale up smaller widgets so that they are more visible in the thumbnail.

To control the scaling of the thumbnail, there are two methods available on the `UseCaseComposer`:
- [`c.overview.minimumSize(width: ..., height: ...)`](../werkbank/OverviewComposer/minimumSize.html)
- [`c.overview.maximumScale(...)`](../werkbank/OverviewComposer/maximumScale.html)

The method [`c.overview.minimumSize(width: ..., height: ...)`](../werkbank/OverviewComposer/minimumSize.html)
sets the minimum size that should be visible in the thumbnail.
So if, for example, the widget from the use case is larger than the thumbnail,
we can call this method with the same or a larger size as the widget,
and the thumbnail will be scaled down until the given width and height fit into the thumbnail.

The method [`c.overview.maximumScale(...)`](../werkbank/OverviewComposer/maximumScale.html)
sets the maximum scale that the thumbnail can have, where a larger scale means that the
use case appears bigger.
If this is not called, the value defaults to 1.
However, you can manually set both smaller and larger values than 1.

In summary, the widget will be scaled as big as possible, such that:
- the [minimum size](../werkbank/OverviewComposer/minimumSize.html) fits into the bounds of the thumbnail,
- and the [maximum scale](../werkbank/OverviewComposer/maximumScale.html) (which defaults to 1) is not exceeded.

For large widgets, you may want to set the [minimum size](../werkbank/OverviewComposer/minimumSize.html)
to the smallest size
they can handle.
Alternatively you can set the [maximum scale](../werkbank/OverviewComposer/maximumScale.html)
to a value smaller than 1 to scale down the thumbnail.
However, since the exact size of the thumbnail depends on how big the main view is scaled,
there can be no guarantee that the widget will fit into the thumbnail when using only the maximum scale.
So to avoid overflows of large widgets, prefer using the
[`c.overview.minimumSize(...)`](../werkbank/OverviewComposer/minimumSize.html)
method instead or both methods in conjunction.

For small widgets, you may want to set the [maximum scale](../werkbank/OverviewComposer/maximumScale.html)
to a value larger than 1.
This way, the thumbnail can be scaled up to make the widget more visible.
However for the same reason as above, consider setting
a [minimum size](../werkbank/OverviewComposer/minimumSize.html)
in addition.

When using the [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html),
calling [`c.constraints.supported(...)`](../werkbank/SupportedSizesComposerExtension/supported.html)
will also set the [minimum size](../werkbank/OverviewComposer/minimumSize.html) to the minimum size supported by the given constraints
unless the parameter `limitOverviewSize` is set to `false`.
So if your widgets really does not support smaller sizes and you also wouldn't want to try them using the
[ConstraintsAddon](../werkbank/ConstraintsAddon-class.html), you can use this method to both limit the supported constraints
that are configurable in the main view and also set the minimum size for the overview.

Here are some examples of what using these methods look like:
```dart
WidgetBuilder myWideWidgetUseCase(UseCaseComposer c) {
  c.overview.minimumSize(width: 600);
  
  return (context) => MyWideWidget();
}
```

```dart
WidgetBuilder myTinyWidgetUseCase(UseCaseComposer c) {
  c.overview.minimumSize(width: 50, height: 50);
  c.overview.maximumScale(3.0);
  
  return (context) => MyTinyWidget();
}
```

### Adjusting the Padding

By default, a small padding is added around the widget inside the thumbnail.
This way, for example, the use case for a text field will not make the text field
directly touch the edges of the thumbnail.
However, something like a whole page may look better if it fills the entire thumbnail.
In that case, you can call
[`c.overview.withoutPadding()`](../werkbank/OverviewComposer/withoutPadding.html)
to remove the padding around the thumbnail.

If the padding was disabled, for example, in a
[`builder`](../werkbank/WerkbankParentNode/builder.html)
of a
[WerkbankFolder](../werkbank/WerkbankFolder-class.html),
you can use
[`c.overview.setHasPadding(hasPadding: true)`](../werkbank/OverviewComposer/setHasPadding.html)
to enable it again.

Here is an example of how this could be used:
```dart
WidgetBuilder myPageUseCase(UseCaseComposer c) {
  c.overview.withoutPadding();
  
  return (context) => MyPage();
}
```

### Adjusting the Use Case Widget

Sometimes you may want to adjust how the widget from the use case is built
when it is displayed in the overview.

To do that, you can call [`UseCase.isInOverviewOf(context)`](../werkbank/UseCase/isInOverviewOf.html)
inside the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
returned by the use case and adjust the returned widget accordingly.

For example, you may want to show a simplified version of the widget:
```dart
WidgetBuilder exampleUseCase(UseCaseComposer c) {
  return (context) {
    if (UseCase.isInOverviewOf(context)) {
      return ExampleThumbnailWidget();
    } else {
      return ExampleWidget();
    }
  };
}
```

### Disabling the Thumbnail

If none of the above methods make your thumbnail look presentable,
you can also disable the thumbnail completely for a use case by calling
[`c.overview.withoutThumbnail()`](../werkbank/OverviewComposer/withoutThumbnail.html).

For example:
```dart
WidgetBuilder superUglyUseCase(UseCaseComposer c) {
  c.overview.withoutThumbnail();
  
  return (context) => SuperUglyWidget();
}
```
