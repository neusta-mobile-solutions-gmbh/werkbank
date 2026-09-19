> [!CAUTION]
> This topic is under construction.

Use case metadata is immutable data that is associated with a use case.

It is constructed during composition of the use case via the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) and can be read
after composition from the [UseCaseMetadata](../werkbank/UseCaseMetadata-class.html).

Metadata is used by many [Addons](../werkbank/Addon-class.html) and Werkbank itself to
store information about use cases.
Some examples are:
- The [descriptions](../werkbank/DescriptionMetadataExtension/descriptions.html),
  [tags](../werkbank/TagsMetadataExtension/tags.html),
  and [URLs](../werkbank/UrlsMetadataExtension/urls.html) 
  introduced by the [DescriptionAddon](../werkbank/DescriptionAddon-class.html).
- The [backgroundOption](../werkbank/BackgroundMetadataExtension/backgroundOption.html)
  selected as default background for the use case using the
  [BackgroundAddon](../werkbank/BackgroundAddon-class.html).
- The [view constraints and presets](../werkbank/ViewConstraintsMetadataExtension.html)
  defined for the use case using the
  [ConstraintsAddon](../werkbank/ConstraintsAddon-class.html).
- The [knob presets](../werkbank/KnobPresetsMetadataExtension.html) 
  defined for the use case using the
  [KnobsAddon](../werkbank/KnobsAddon-class.html).
- The [overviewSettings](../werkbank/OverviewSettingsMetadataExtension/overviewSettings.html)
  that define how the use case is displayed in the overview.
- And many more.

When simply writing use cases, you usually do not interact with the metadata directly but
rather use methods like
[`c.description(...)`](../werkbank/DescriptionComposerExtension/description.html),
[`c.background.named(...)`](../werkbank/BackgroundComposer/named.html) or
[`c.overview.minimumSize(...)`](../werkbank/OverviewComposer/minimumSize.html) on the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html), which internally
read, write, or modify the metadata of the use case.

During composition, it is possible to read the current state of the metadata
and make changes to it depending on that.

The metadata of a use case can be read from the
[UseCaseMetadata](../werkbank/UseCaseMetadata-class.html) class.
There are several ways to obtain an instance of this class:
- Within the [WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
  returned by the [builder](../werkbank/WerkbankUseCase/builder.html) of a
  use case via [`UseCase.metadataOf(context)`](../werkbank/UseCase/metaDataOf.html).
- By calling [`useCaseDescriptor.computeMetadata(addonConfig)`](../werkbank/UseCaseDescriptor/computeMetadata.html)
  on a [UseCaseDescriptor](../werkbank/UseCaseDescriptor-class.html) which can be obtained
  using [`RootDescriptor.fromWerkbankSections(sections)`](../werkbank/RootDescriptor/RootDescriptor.fromWerkbankSections.html).
  - This can be useful when writing tests using the [Display](Display-topic.html).
    See [Testing with Use Cases](Testing%20with%20Use%20Cases-topic.html) for more information on that.
- When developing an addon by calling [`accessor.metadataOf(context)`](../werkbank/UseCaseAccessorMixin/metadataOf.html)
  on an [AddonAccessor](../werkbank/AddonAccessor-class.html) that implements
  [UseCaseAccessorMixin](../werkbank/UseCaseAccessorMixin-class.html).
  - See [Writing Your Own Addons](Writing%20Your%20Own%20Addons-topic.html) for more information on that.
- From a [UseCaseComposition](../werkbank/UseCaseComposition-class.html) using
  [`composition.metadata`](../werkbank/UseCaseComposition/metadata.html).

## Defining Custom Metadata

