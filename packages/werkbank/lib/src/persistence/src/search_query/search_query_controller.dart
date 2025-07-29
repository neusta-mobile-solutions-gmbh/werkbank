import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class SearchQueryController
    extends PersistentController<SearchQueryController> {
  SearchQueryController({
    required WasAliveController wasAliveController,
  }) : _wasAliveController = wasAliveController,
       super(id: 'search_query');

  final WasAliveController _wasAliveController;

  // When the query hits around 50 characters, the bitap algorithm
  // leads to weird results. So we limit the query length.
  static const int maxQueryLength = 42;

  @override
  void tryLoadFromJson(Object? json) {
    if (_wasAliveController.isColdAppStart) {
      return;
    }
    try {
      _persistentData = SearchQueryPersistentData.fromJson(json);
      notifyListeners();
    } on FormatException {
      debugPrint(
        'Restoring SearchQueryPersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
    }
  }

  @override
  Object? toJson() {
    return _persistentData.toJson();
  }

  // TODO: Move to somewhere else
  late final FocusNode focusNode = FocusNode();

  SearchQueryPersistentData _persistentData = const SearchQueryPersistentData(
    query: '',
  );

  String get query {
    return _persistentData.query;
  }

  void updateSearchQuery(String query) {
    _persistentData = SearchQueryPersistentData(query: query);
    notifyListeners();
  }

  void reset() {
    _persistentData = const SearchQueryPersistentData(query: '');
    notifyListeners();
  }
}
