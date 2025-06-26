# 0.15.1
- Make some improvements to use case descriptions
  - Rename the "About" section for descriptions to "Description".
  - Calling `c.description(...)` multiple times in the same node will now merge the descriptions instead of always overwriting them.
    - How the descriptions are merged can be controlled by the new `mergeStrategy` parameter.
  - Added `forUseCase` parameter for `c.description(...)` to specify whether the description is for the use case or the current node.
  - The name of a `WerkbankFolder` or `WerkbankComponent` is now displayed above its description.

# 0.15.0

- Initial release
