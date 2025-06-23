import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class _SearchMetadataEntry extends UseCaseMetadataEntry<_SearchMetadataEntry> {
  const _SearchMetadataEntry(this.searchClusters);

  final IList<SearchCluster> searchClusters;
}

extension SearchMetadataExtension on UseCaseMetadata {
  List<SearchCluster> get searchClusters =>
      (get<_SearchMetadataEntry>()?.searchClusters ?? const IList.empty())
          .unlockView;
}

extension UseCaseComposerSearchExtension on UseCaseComposer {
  void addSearchCluster(
    SearchCluster searchCluster,
  ) {
    final currentSearchClusters =
        getMetadata<_SearchMetadataEntry>()?.searchClusters ??
        const IList.empty();
    setMetadata(
      _SearchMetadataEntry(
        currentSearchClusters.add(searchCluster),
      ),
    );
  }
}
