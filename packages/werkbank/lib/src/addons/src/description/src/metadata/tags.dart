import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class _TagsMetadataEntry extends UseCaseMetadataEntry<_TagsMetadataEntry> {
  const _TagsMetadataEntry(this.tags);

  final IList<String> tags;
}

extension TagsMetadataExtension on UseCaseMetadata {
  List<String> get tags =>
      (get<_TagsMetadataEntry>()?.tags ?? const IList.empty()).unlockView;
}

extension TagsComposerExtension on UseCaseComposer {
  void tags(List<String> tags) {
    final currentTags =
        getMetadata<_TagsMetadataEntry>()?.tags ?? const IList.empty();
    setMetadata(
      _TagsMetadataEntry(
        currentTags.addAll(tags.map((tag) => tag.toUpperCase())),
      ),
    );
    addSearchCluster(
      SearchCluster(
        semanticDescription: 'Tag',
        field: DescriptionAddon.tagField,
        entries: tags
            .map(
              (tag) => FuzzySearchEntry(
                searchString: tag,
                ignoreCase: true,
              ),
            )
            .toList(),
      ),
    );
  }
}
