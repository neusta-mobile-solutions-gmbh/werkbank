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
<!-- - limiting the applied constraints to a supported range to avoid confusion  (Too much, too specific) -->

> [!Note]
> If you disable the ConstraintsAddon for your project, the applied constraints are infinite by default.
  
## Change constraints

- with textfields
- "view"
- "inf"
- with rules
  - only min
  - only max
  - both
- with shortcut
  - only min
  - only max
  - both
- swap button
- klick in ecke -> nicht "initial" sondern 0 - view

- Tip: Works very good with viewer addon, especially for small or large constraints. (move and zoom)

## See resulting size.

- size textfields

### Change constraints by changing size

- change textfields
- lock button (leif fragen warum)

## setup constraints for use case

### initial

- initial -> 0 - view
- initial änderbar
- c.constraints.initial;
- c.constraints.initialConstraints;
- c.constraints.initialSize;

### presets

- c.constraints.preset
- c.constraints.presetConstraints
- c.constraints.presetSize
- c.constraints.devicePresets;
  
### suported

- c.constraints.supported

### ?

- c.constraints.overview
- c.constraints.overviewConstraints
- c.constraints.overviewSize

- Unterscheidung use case, component, oder lieber nur vom use case sprechen?



<!--
Recycle this?

- Drag the rulers at the top and left of the main view to change both axes
- Hold `Shift` (⇧) or `Alt` (⌥) to set only minimum or maximum constraints
- Hold both keys to set tight constraints by dragging over the use case
- Use the text fields in the "CONFIGURE" tab under the "Constraints" section for precise values
-->
