import 'package:fuzzy/bitap/bitap.dart';
import 'package:fuzzy/data/fuzzy_options.dart';
import 'package:werkbank/src/werkbank_internal.dart';

sealed class SearchEntry {
  SearchResultEntry evaluate(String query);
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

class FuzzySearchEntry extends SearchEntry implements FuzzySearchData {
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
  SearchResultEntry evaluate(String query) {
    final bitap = Bitap(
      query,
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

abstract class IgnoreCaseSearchData {
  IgnoreCaseSearchData({
    required this.searchString,
    required this.minCharsForMatch,
  });

  final String searchString;
  final int minCharsForMatch;
}

class IgnoreCaseSearchEntry extends SearchEntry
    implements IgnoreCaseSearchData {
  IgnoreCaseSearchEntry({
    required this.searchString,
    this.minCharsForMatch = 3,
  });

  @override
  final String searchString;
  @override
  final int minCharsForMatch;

  @override
  SearchResultEntry evaluate(String query) {
    final ignoreCaseMatch =
        query.length >= minCharsForMatch &&
        searchString.toLowerCase().contains(query.toLowerCase());

    return IgnoreCaseSearchEntryResult(
      searchString: searchString,
      minCharsForMatch: minCharsForMatch,
      isMatch: ignoreCaseMatch,
    );
  }
}

class ExactMatchSearchData {
  ExactMatchSearchData({
    required this.searchString,
    required this.minCharsForMatch,
  });

  final String searchString;
  final int minCharsForMatch;
}

class ExactMatchSearchEntry extends SearchEntry
    implements ExactMatchSearchData {
  ExactMatchSearchEntry({
    required this.searchString,
    this.minCharsForMatch = 3,
  });

  @override
  final String searchString;
  @override
  final int minCharsForMatch;

  @override
  SearchResultEntry evaluate(String query) {
    final exactMatch =
        query.length >= minCharsForMatch && searchString.contains(query);

    return ExactMatchSearchEntryResult(
      searchString: searchString,
      minCharsForMatch: minCharsForMatch,
      isMatch: exactMatch,
    );
  }
}
