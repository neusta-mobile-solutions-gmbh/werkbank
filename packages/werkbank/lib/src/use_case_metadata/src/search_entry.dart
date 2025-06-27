import 'package:fuzzy/bitap/bitap.dart';
import 'package:fuzzy/data/fuzzy_options.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Search for Use Cases}
abstract class SearchEntry {
  const SearchEntry({required this.searchString});

  SearchResultEntry evaluate(
    FilterCommand filterCommand,
    SearchCluster parentCluster,
  );

  final String searchString;
}

abstract class FuzzySearchData {
  FuzzySearchData({
    required this.searchString,
    required this.scoreThreshold,
    required this.ignoreCase,
  });

  final String searchString;

  /// The maximum score that is considered a match.
  /// At what point does the match algorithm give up. A threshold of '0.0'
  /// requires a perfect match
  /// (of both letters and location), a threshold of '1.0' would match anything.
  final Score scoreThreshold;

  final bool ignoreCase;
}

/// {@category Search for Use Cases}
class FuzzySearchEntry implements SearchEntry, FuzzySearchData {
  FuzzySearchEntry({
    required this.searchString,
    this.scoreThreshold = .4,
    this.ignoreCase = false,
  }) : assert(
         scoreThreshold >= 0 && scoreThreshold <= 1,
         'The score threshold must be between 0 and 1',
       );

  @override
  final String searchString;

  @override
  final Score scoreThreshold;

  @override
  final bool ignoreCase;

  @override
  SearchResultEntry evaluate(
    FilterCommand filterCommand,
    SearchCluster parentCluster,
  ) {
    final fieldMismatch =
        filterCommand.field != null &&
        filterCommand.field != parentCluster.field;
    if (fieldMismatch || filterCommand.patternInvalid) {
      return OverwrittenSearchEntryResult(
        searchString: searchString,
        isMatch: false,
      );
    }

    if (filterCommand.precise) {
      return OverwrittenSearchEntryResult(
        searchString: searchString,
        isMatch: _ignoreCaseMatch(filterCommand, searchString),
      );
    }

    // Default case

    final bitap = Bitap(
      filterCommand.searchQuery,
      options: FuzzyOptions(
        threshold: scoreThreshold,
        isCaseSensitive: !ignoreCase,
      ),
    );

    final matchScore = bitap.search(searchString);

    return FuzzySearchEntryResult(
      searchString: searchString,
      scoreThreshold: scoreThreshold,
      score: matchScore.score,
      isMatch: matchScore.isMatch,
      ignoreCase: ignoreCase,
    );
  }
}

bool _ignoreCaseMatch(FilterCommand filterCommand, String searchString) =>
    filterCommand.searchQuery.isNotEmpty &&
    searchString.toLowerCase().contains(
      filterCommand.searchQuery.toLowerCase(),
    );
