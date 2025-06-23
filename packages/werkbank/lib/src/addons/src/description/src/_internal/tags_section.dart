import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({
    required this.tags,
    super.key,
  });

  final List<String> tags;

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
        )?.updateSearchQuery(tag);
      },
      label: Text(
        tag,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
