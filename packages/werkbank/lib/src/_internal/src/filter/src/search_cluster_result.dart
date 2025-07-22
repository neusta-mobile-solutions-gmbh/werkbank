import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class SearchClusterResult extends SearchClusterFoundation
    implements SearchResult {
  SearchClusterResult({
    required super.semanticDescription,
    required super.field,
    required this.entries,
  }) : assert(
         entries.isNotEmpty,
         'entries must not be empty',
       );

  final IList<SearchResultEntry> entries;

  @override
  late final bool isMatch = entries.any((e) => e.isMatch);

  @override
  String toString() {
    return 'SearchClusterResult{isMatch: $isMatch, '
        'semanticDescription: $semanticDescription, '
        'field: $field, '
        'entries: $entries}';
  }
}
