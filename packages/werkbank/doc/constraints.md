When it comes to sizing, Flutter has its own smart technique for that: the constraints model. This way widgets can decide on what size they will become bounded by a minimum and maximum size defined by their parent. This topic is about what Werkbank offers you to work with Flutters constraints, to ensure that your component behaves as you intend for all constraints that matter to you.
Before reading this, we recommend [understanding constraints](https://docs.flutter.dev/ui/layout/constraints) first and reading [Writing Use Cases](Getting%20Started-topic.html), or being familiar with Werkbank.

**Table of Contents**

## ConstraintsAddon

By default, Werkbank comes with the ConstraintsAddon, which aims to provide support for using and understanding Flutter's constraints system. It offers a variety of features, such as

- changing the constraints applied to the component at runtime
  - freely by hand using the pointer
  - precise using text fields
  - checking the size that the component actually has after its layout phase
  - setting the initial constraints applied to a component
  - defining presets ...
  <!-- - limiting the applied constraints to a supported range to avoid confusion  (Too much, too specific) -->

We will go through them one at a time.

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
