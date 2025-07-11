import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class SearchQueryController extends PersistentController {
  SearchQueryController({
    required super.prefsWithCache,
    required WasAliveController wasAliveController,
  }) : _wasAliveController = wasAliveController;

  final WasAliveController _wasAliveController;

  @override
  String get id => 'search_query';

  // When the query hits around 50 characters, the bitap algorithm
  // leads to weird results. So we limit the query length.
  static const int maxQueryLength = 42;

  @override
  void init(String? unsafeJson) {
    const fallback = SearchQueryPersistentData(query: '');

    try {
      _persistentData =
          unsafeJson != null && !_wasAliveController.isColdAppStart
          ? SearchQueryPersistentData.fromJson(jsonDecode(unsafeJson))
          : fallback;
    } on FormatException {
      debugPrint(
        'Restoring SearchQueryPersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
      _persistentData = fallback;
    }
  }

  late final FocusNode focusNode = FocusNode();

  late SearchQueryPersistentData _persistentData;

  String get query {
    return _persistentData.query;
  }

  void updateSearchQuery(String query) {
    _persistentData = SearchQueryPersistentData(query: query);
    _update();
  }

  void reset() {
    _persistentData = const SearchQueryPersistentData(query: '');
    _update();
  }

  void _update() {
    setJson(jsonEncode(_persistentData.toJson()));
    notifyListeners();
  }
}
