import 'package:werkbank/src/use_case_metadata/use_case_metadata.dart';

typedef Score = double;

/// {@category Search for Use Cases}
abstract class SearchResult {
  SearchResult({
    required this.isMatch,
  });

  final bool isMatch;
}

/// {@category Search for Use Cases}
abstract class SearchResultEntry {
  SearchResultEntry({
    required this.isMatch,
  });

  final bool isMatch;
}

/// {@category Search for Use Cases}
class FuzzySearchEntryResult implements SearchResultEntry, FuzzySearchData {
  FuzzySearchEntryResult({
    required this.isMatch,
    required this.searchString,
    required this.score,
    required this.scoreThreshold,
    required this.ignoreCase,
  });

  @override
  final bool isMatch;

  @override
  final String searchString;

  final Score score;

  @override
  final Score scoreThreshold;

  @override
  final bool ignoreCase;

  @override
  String toString() {
    return 'FuzzySearchEntryResult{'
        'isMatch: $isMatch, '
        'searchString: ${searchString.maxLength(50)}, '
        'score: ${score.toStringAsFixed(2)}, '
        'scoreThreshold: $scoreThreshold, '
        'ignoreCase: $ignoreCase'
        '}';
  }
}

class OverwrittenSearchEntryResult extends SearchResultEntry {
  OverwrittenSearchEntryResult({
    required this.searchString,
    required super.isMatch,
  });

  final String searchString;

  @override
  String toString() {
    return 'OverwrittenSearchEntryResult{'
        'searchString: ${searchString.maxLength(50)}, '
        'isMatch: $isMatch'
        '}';
  }
}

extension on String {
  String maxLength(int length) {
    return length < this.length ? '${substring(0, length)}…' : this;
  }
}
