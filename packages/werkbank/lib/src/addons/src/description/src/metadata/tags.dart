import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/addons/src/description/description.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/use_case_metadata/use_case_metadata.dart';

class _TagsMetadataEntry extends UseCaseMetadataEntry<_TagsMetadataEntry> {
  const _TagsMetadataEntry(this.tags);

  final ISet<String> tags;
}

extension TagsMetadataExtension on UseCaseMetadata {
  Set<String> get tags =>
      (get<_TagsMetadataEntry>()?.tags ?? const ISet.empty()).unlockView;
}

extension TagsComposerExtension on UseCaseComposer {
  void tags(List<String> tags) {
    final currentTags =
        getMetadata<_TagsMetadataEntry>()?.tags ?? const ISet.empty();
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
