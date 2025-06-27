import 'package:equatable/equatable.dart';

class FilterCommand
    with
        // For toString-Method
        EquatableMixin {
  factory FilterCommand({required String searchQuery}) {
    return _parse(searchQuery);
  }

  FilterCommand._({
    required this.searchQuery,
    this.field,
    this.precise = false,
    this.patternInvalid = false,
  });

  final String searchQuery;
  final String? field;
  final bool precise;
  final bool patternInvalid;

  @override
  List<Object?> get props => [
    searchQuery,
    field,
    precise,
    patternInvalid,
  ];
}

FilterCommand _parse(String searchQuery) {
  final colonsPositions = RegExp(
    ':',
  ).allMatches(searchQuery).map((m) => m.start).toList();
  final colonsCount = colonsPositions.length;
  final containsColon = colonsCount > 0;

  final doubleQuotesPositions = RegExp(
    '"',
  ).allMatches(searchQuery).map((m) => m.start).toList();
  final doubleQuotesCount = doubleQuotesPositions.length;
  final containsDoubleQuotes = doubleQuotesCount > 0;

  final doesntContainKeySymbols = !containsColon && !containsDoubleQuotes;

  if (doesntContainKeySymbols) {
    // Default case
    return FilterCommand._(
      searchQuery: searchQuery,
    );
  }

  final containsInvalidSymbolsAmount = colonsCount > 1 || doubleQuotesCount > 2;

  if (containsInvalidSymbolsAmount) {
    return FilterCommand._(
      searchQuery: searchQuery,
      patternInvalid: true,
    );
  }

  final rightSymbolOrder =
      (colonsPositions.firstOrNull ?? 0) <=
      (doubleQuotesPositions.firstOrNull ?? searchQuery.length);

  if (!rightSymbolOrder) {
    return FilterCommand._(
      searchQuery: searchQuery,
      patternInvalid: true,
    );
  }

  final searchQueryParts = searchQuery.split(':');
  final field = searchQueryParts.length > 1 ? searchQueryParts.first : null;

  final remainingSearchQuery = searchQueryParts.length > 1
      ? searchQueryParts.last
      : searchQuery;

  if (!containsDoubleQuotes) {
    return FilterCommand._(
      searchQuery: remainingSearchQuery,
      field: field,
    );
  }

  final remainingSearchQueryParts = remainingSearchQuery.split('"');

  final doubleQuotesPositionsValid =
      remainingSearchQueryParts.first.isEmpty &&
      (remainingSearchQueryParts.length == 2 ||
          (remainingSearchQueryParts.length == 3 &&
              remainingSearchQueryParts.last.isEmpty));

  if (!doubleQuotesPositionsValid) {
    return FilterCommand._(
      searchQuery: searchQuery,
      patternInvalid: true,
    );
  }

  final actualSearchQuery = remainingSearchQueryParts[1];

  return FilterCommand._(
    searchQuery: actualSearchQuery,
    field: field,
    precise: true,
  );
}
