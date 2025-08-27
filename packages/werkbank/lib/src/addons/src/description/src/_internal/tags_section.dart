import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/description/description.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/persistence/persistence.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({
    required this.tags,
    super.key,
  });

  final Set<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final tag in tags) Tag(tag: tag),
      ],
    );
  }
}

class Tag extends StatelessWidget {
  const Tag({
    required this.tag,
    super.key,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return WChip(
      onPressed: () {
        WerkbankPersistence.maybeSearchQueryController(
          context,
        )?.updateSearchQuery('${DescriptionAddon.tagField}:"$tag"');
      },
      label: Text(
        tag,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
