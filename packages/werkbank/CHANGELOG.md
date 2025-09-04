# 0.17.1
- Improve semantics inspector
  - Fix that merged semantics nodes were shown by default.
  - Make showing merged nodes an option. (Hidden by default.)
  - Make showing hidden nodes an option. (Shown by default.)
  - Merged and hidden nodes are now clearly marked as such in the tree.
  - Add the properties `isMergedIntoParent`, `mergeAllDescendantsIntoThisNode` and `areUserActionsBlocked` to the "Active Semantics Node" section.
  - Add option to change the inspection scope. The choices are:
    - "Use Case" (new default)
      - Only the semantics of the use case itself is shown.
    - "App" (previous implicit behavior)
      - The semantics of the whole use case-app (so the app as defined by the `AppConfig`, not the whole `WerkbankApp`) is shown.
      - This scope allows you to see the semantics of routes or other overlays introduced by the use case.
      - However it usually shows two additional semantics nodes as parents of your use case semantics that are introduced by the app and routing. Most of the time these nodes are not interesting.


# 0.17.0
- Add `StateKeepingAddon` to keep states in the use case.
  - The feature is similar to knobs, just without controls in the UI and with a support for a wider range of types.
  - Immutable state, like primitive values or data classes, can be added by calling `c.states.immutable(...)`.
  - Mutable state, like controllers, can be added by calling `c.states.mutable(...)`.
  - Read the documentation topic at https://pub.dev/documentation/werkbank/latest/topics/Keeping%20State-topic.html
- Add "Writing Use Cases" documentation topic that provides an overview of techniques you can use to customize your use cases.
  - Give it a read at https://pub.dev/documentation/werkbank/latest/topics/Writing%20Use%20Cases-topic.html
- Update to Flutter 3.35.x. **(BREAKING CHANGE)**
  - Since we now use the new APIs, you will need to update your Flutter SDK to at least 3.35.0.
- Make changes to `BackgroundOption` constructors to be more consistent with `c.background.<...>` functions in the `BackgroundComposer`.
  - The unnamed `BackgroundOption(...)` constructor is now `BackgroundOption.widget(...)`. **(BREAKING CHANGE)**
  - Changed `BackgroundOption.color(...)` constructor to allow specifying a color directly. **(BREAKING CHANGE)**
  - The old `BackgroundOption.color(...)` constructor is now `BackgroundOption.colorBuilder(...)`. **(BREAKING CHANGE)**
  - The `BackgroundOption.builder(...)` constructor is now `BackgroundOption.widgetBuilder(...)`. **(BREAKING CHANGE)**
  - Some parameter names have also been renamed.
- Fix merging behavior of tags.
- Navigating back to home using "ESC" or the top-left project info area no longer clears the search text field
- Fix that Markdown link did not work in some places such as in reports.
- Remove some things related to knobs that were deprecated in 0.16.1. **(BREAKING CHANGE)**
- Fix that the semantics of backgrounds were not excluded. (For example the checkered background was showing up as an image in the semantics inspector.)

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
