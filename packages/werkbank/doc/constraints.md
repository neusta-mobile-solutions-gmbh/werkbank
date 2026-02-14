Flutter uses a constraints model for widget sizing, where parent widgets pass constraints (minimum and maximum width and height) down to their children, and each child decides on its size within those bounds. This topic covers how Werkbank helps you work with Flutter's constraints to ensure your components behave as intended across different constraints.
Before reading this, we recommend [understanding constraints](https://docs.flutter.dev/ui/layout/constraints) first and reading [Writing Use Cases](Getting%20Started-topic.html), or being familiar with Werkbank.

**Table of Contents**

## Key Features ConstraintsAddon

By default, Werkbank comes with the ConstraintsAddon, which provides support for using and understanding Flutter's constraints system. It offers a variety of features, such as:

- changing the constraints applied to the component at runtime
  - freely by hand using the pointer
  - precisely using text fields
- checking the size that the component actually has after its layout phase
- setting the initial constraints applied to a component
- defining presets
- and much more

> [!Note]
> If you disable the ConstraintsAddon for your project, the applied constraints are infinite by default.

## Applied constraints and the resulting size

The "CONFIGURE" tab of the Werkbank UI contains a constraints section with text fields that display the constraints currently applied to your component. Below these, you'll find text fields showing the resulting size your component has laid itself out to. This size updates in real-time within the same frame as the constraints change, not post-frame. Additionally, rulers at the top and left of the main view also display the size.

Initially, the max-constraints text fields show **"VIEW"**, meaning the component can be as large as the main view of your Werkbank UI.

## Change constraints at runtime

There are several ways to modify the constraints applied to your component. Using the UI, you can:

- Set **precise values using text fields**
  - Type "INF" to set infinite max constraints
  - Additionally setting values in the size text fields will result in tight constraints
- **Drag on a ruler** at the top and left of the main view to set tight constraints for the corresponding axis
  - Hold `Shift` (⇧) or `Alt` (⌥) to set only minimum or maximum constraints 
- **Drag over the main view** while holding `Shift` (⇧) or `Alt` (⌥) to set only minimum or maximum constraints
  - Hold both keys to set tight constraints while dragging

Additional options include:
- A **swap button** next to the constraints text fields to exchange width and height constraints
- **Click the top-left corner** of the ruler to quickly set constraints to `0 - VIEW`

> [!Tip]
> The **ViewerAddon** works particularly well with constraint testing, especially for very small or large constraints, as it allows you to move and zoom the view.

## Setup constraints for a use case

By default, use case constraints are set to `0 - VIEW`, which corresponds to loose constraints that allow the component to be as large as the main view.

You can customize the **initial constraints** of a use case during its composition phase:

```dart
// Use one of these functions
c.constraints.initial(height: 200, width: 400);
c.constraints.initialConstraints(
  BoxConstraints(/* constraints */),
);
c.constraints.initialSize(Size(/* size */));
```

### Define presets for constraints

Similar to [Knobs](topic-link), you can set up presets for your constraints that appear as selectable options in a dropdown within the constraints section of the "CONFIGURE" tab.

You can define presets using one of these functions:

```dart
c.constraints.preset('Small', width: 100);
c.constraints.presetConstraints(/* Settings */);
c.constraints.presetSize(/* Settings */);
c.constraints.devicePresets();
```

### Predefined device presets

When working with a use case that will fill the entire screen or page, using `c.constraints.devicePresets()` is especially useful. This function adds several presets to your use case with realistic device sizes, making it easy to see how your component would look on devices with those dimensions.
  
### Define supported constraints

You may want to indicate that your component is only designed to look good within a specific range of sizes. Since Werkbank allows you to apply any constraints to your use case, defining supported constraints can help avoid confusion, especially when working in large teams. Use `c.constraints.supported(/*constraints*/)` to specify the constraint range where your component should perform optimally. This also makes it impossible to set constraints outside of this bounds to the use case.


### ?

- c.constraints.overview
- c.constraints.overviewConstraints
- c.constraints.overviewSize
- lock button (leif fragen warum)
- Unterscheidung use case, component, oder lieber nur vom use case sprechen?


<!--
Recycle this?

- Hold `Shift` (⇧) or `Alt` (⌥) to set only minimum or maximum constraints
- Hold both keys to set tight constraints by dragging over the use case
- Use the text fields in the "CONFIGURE" tab under the "Constraints" section for precise values
-->
