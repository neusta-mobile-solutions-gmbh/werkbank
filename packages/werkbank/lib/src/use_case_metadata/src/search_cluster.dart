import 'package:fast_immutable_collections/fast_immutable_collections.dart';

abstract class SearchClusterFoundation {
  SearchClusterFoundation({
    required this.semanticDescription,
    required this.field,
  });

  /// Describes the meaning or context of this search cluster.
  /// For example: "Description of the use case", "Tag", or "Name".
  /// Used to provide context for search results
  /// when activating [DebugWerkbankFilter]
  final String semanticDescription;

  /// This allows the user to refine a search
  /// by restricting results to entries that match a specific field,
  /// such as "field:searchString".
  /// For Example:
  /// "tag:interactive"
  final String field;
}

/// {@category Search for Use Cases}
class SearchCluster extends SearchClusterFoundation {
  SearchCluster({
    required this.entries,
    required super.semanticDescription,
    required super.field,
  }) : assert(
         entries.isNotEmpty,
         'entries must not be empty',
       );

  final List<SearchEntry> entries;

  SearchClusterResult evaluate({required FilterCommand filterCommand}) {
    return SearchClusterResult(
      semanticDescription: semanticDescription,
      field: field,
      entries: entries.map((e) => e.evaluate(filterCommand, this)).toIList(),
    );
  }
}
