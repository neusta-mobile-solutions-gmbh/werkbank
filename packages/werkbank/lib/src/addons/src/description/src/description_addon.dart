import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/description/src/_internal/description_section.dart';
import 'package:werkbank/src/addons/src/description/src/_internal/tags_homepage_component.dart';
import 'package:werkbank/src/addons/src/description/src/_internal/tags_section.dart';
import 'package:werkbank/src/addons/src/description/src/_internal/urls_section.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Configuring Addons}
/// This addon provides the ability to add a description, urls and tags
/// to a node and displays them in the configuration panel.
///
/// Example Usage:
/// ```dart
/// WidgetBuilder nameUseCase(UseCaseComposer c) {
///   c.description('description, supporting markdown.');
///   c.urls(['https://figma.com']);
///   return (context) {
///     return widget;
///   };
/// }
///```
///
class DescriptionAddon extends Addon {
  const DescriptionAddon() : super(id: addonId);

  static const addonId = 'description';

  @override
  List<HomePageComponent> buildHomePageComponents(BuildContext context) {
    final tags =
        {
            for (final metadata
                in HomePageComponent.access.metadataMapOf(context).values)
              ...metadata.tags,
          }.toList(growable: false)
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return [
      if (tags.isNotEmpty)
        HomePageComponent(
          sortHint: SortHint.central,
          title: Text(context.sL10n.addons.description.tags),
          child: TagsHomepageComponent(tags: tags),
        ),
    ];
  }

  @override
  List<InfoControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) {
    final metadata = InfoControlSection.access.metadataOf(context);
    final useCaseDescription = metadata.descriptions.useCaseDescription;
    final componentDescription = metadata.descriptions.componentDescription;
    final folderDescriptions =
        metadata.descriptions.folderDescriptions.reversed;

    final hasAnyDescription =
        useCaseDescription != null ||
        componentDescription != null ||
        (folderDescriptions.isNotEmpty);

    final urls = metadata.urls;

    return [
      if (metadata.tags.isNotEmpty)
        InfoControlSection(
          id: 'tags',
          title: Text(context.sL10n.addons.description.tags),
          children: [
            TagsSection(
              tags: metadata.tags,
            ),
          ],
        ),
      if (hasAnyDescription)
        InfoControlSection(
          id: 'description',
          title: Text(context.sL10n.addons.description.description),
          children: [
            if (useCaseDescription != null)
              DescriptionSection(
                data: useCaseDescription,
              ),
            if (componentDescription != null)
              DescriptionSection(
                data: componentDescription,
                hint: Text(context.sL10n.addons.description.component),
              ),
            if (folderDescriptions.isNotEmpty)
              for (final folderDescription in folderDescriptions)
                DescriptionSection(
                  data: folderDescription,
                  hint: Text(
                    context.sL10n.addons.description.folder,
                  ),
                ),
          ],
        ),
      if (urls.isNotEmpty)
        InfoControlSection(
          id: 'urls',
          title: Text(context.sL10n.addons.description.links),
          children: [
            UrlsSection(
              urls: urls,
            ),
          ],
        ),
    ];
  }
}
