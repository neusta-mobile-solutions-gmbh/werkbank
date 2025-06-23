import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/description/src/_internal/tags_section.dart';

class TagsHomepageComponent extends StatelessWidget {
  const TagsHomepageComponent({required this.tags, super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final tag in tags) Tag(tag: tag),
        ],
      ),
    );
  }
}
