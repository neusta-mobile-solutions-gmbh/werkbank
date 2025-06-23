import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/werkbank_internal.dart';

abstract class SearchClusterFoundation {
  SearchClusterFoundation({
    required this.semanticDescription,
  });

  /// Describes the meaning or context of this search cluster.
  /// For example: "Description of the use case", "Tag", or "Name".
  /// Used to provide context for search results
  /// when activating [DebugWerkbankFilter]
  final String semanticDescription;
}

class SearchCluster extends SearchClusterFoundation {
  SearchCluster({
    required this.entries,
    required super.semanticDescription,
  }) : assert(
         entries.isNotEmpty,
         'entries must not be empty',
       );

  final List<SearchEntry> entries;

  SearchClusterResult evaluate({required String query}) {
    return SearchClusterResult(
      semanticDescription: semanticDescription,
      entries: entries.map((e) => e.evaluate(query)).toIList(),
    );
  }
}
