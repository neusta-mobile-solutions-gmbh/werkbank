# 0.16.2
- Increase maximum `go_router` version to 16.x.x and lower minimum version to 13.1.0.
  This should lower the risk of dependency conflicts.

# 0.16.1
- Added a `Werkbank System` theme, which will always match your system. It's also default now.
- Add a "Knobs" documentation topic which explains how to create your own knobs.
- Deprecate `list` knob. Use `customDropdown` instead.
- Rename `valueFormatter` parameters in `doubleSlider` and `intSlider` knobs to `valueLabel`.
  The old parameter names are still available but deprecated.
- Add `customDropdown` knob.
  - Compared to `list`, some parameters were changed to be more consistent with other knobs.
- Add new knobs with generic return types that allow you to create custom knobs with little effort:
  - `c.knobs.customField<T>(...)` and `c.knobs.customFieldMultiLine<T>(...)` (for custom text field controlled knobs)
  - `c.knobs.customSlider<T>(...)` (for custom slider controlled knobs)
  - `c.knobs.customSwitch<T>(...)` (for custom switch controlled knobs)
  - And the corresponding nullable variants.
- Add `intField` and `doubleField` knobs.
- Add `falseLabel` and `trueLabel` parameters to `c.knobs.boolean(...)` to allow customizing the labels of the switch.
- Rename `NullableKnobs` to `NullableKnobsComposer`. The old type is still available but deprecated.
- Improve code documentation of knobs.

# 0.16.0
- Add `c.background.colorBuilder(...)` and `c.background.widgetBuilder(...)` to allow easier use of theme colors in backgrounds.
- Fix that pointer could interact with use case while trying to change constraints.
- Make small changes to the tree UI to make it easier to overview the items and find the selected item.
- Change icons of use cases and components.
- Add `WerkbankLogo` widget.
- Rename `WerkbankSections` to `WerkbankRoot`. **(BREAKING CHANGE)**
  - This also means that the `sections` parameter of `WerkbankApp` has been renamed to `root`.
- Rename `UseCaseControlSection` to `ConfigureControlSection` and `InfoControlSection` to `InspectControlSection`. **(BREAKING CHANGE)**
  - This change should only affect custom addon authors.
  - The tabs had been renamed from "USE CASE" to "CONFIGURE" and from "INFO" to "INSPECT" some time ago. However, these classes were missed.
- Rename `UseCaseMetadataBuilder` to `UseCaseParentBuilder`. **(BREAKING CHANGE)**
- Extend `Report`'s to be collapsible when enabled; this is now used for shortcuts on the homepage.

# 0.15.1
- Make some improvements to use case descriptions
  - Rename the "About" section for descriptions to "Description".
  - Calling `c.description(...)` multiple times in the same node will now merge the descriptions instead of always overwriting them.
    - How the descriptions are merged can be controlled by the new `mergeStrategy` parameter.
  - Added `forUseCase` parameter for `c.description(...)` to specify whether the description is for the use case or the current node.
  - The name of a `WerkbankFolder` or `WerkbankComponent` is now displayed above its description.
- Fix that semantics inspector in "Inspection" mode would not allow to select semantic boxes in the main view on web.
- Add custom semantics actions to semantics inspector.
- Add advanced search features. TL;DR: `fuzzy text`, `<field>:fuzzy text`, `"precise text"`, `<field>:"precise text"`
- Add ability to check if an addon is active using the `UseCaseComposer` by doing `c.isAddonActive(SomeAddon.addonId)`.
- Replace a few dependencies and fix lints to make pub.dev happy.

# 0.15.0

- Initial release
