
# 0.16.0
- Add `c.background.colorBuilder(...)` and `c.background.widgetBuilder(...)` to allow easier use of theme colors in backgrounds.
- Fix that pointer could interact with use case while trying to change constraints.
- Make small changes to the tree UI to make it easier to overview the items and find the selected item.
- Rename `WerkbankSections` to `WerkbankRoot`. **(BREAKING CHANGE)**
  - This also means that the `sections` parameter of `WerkbankApp` has been renamed to `root`.
- Rename `UseCaseControlSection` to `ConfigureControlSection` and `InfoControlSection` to `InspectControlSection`. **(BREAKING CHANGE)**
  - This change should only affect custom addon authors.
  - The tabs had been renamed from "USE CASE" to "CONFIGURE" and from "INFO" to "INSPECT" some time ago. However these classes were missed.

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
- Replace a few dependencies and fix lints to make pub.dev happy.

# 0.15.0

- Initial release
