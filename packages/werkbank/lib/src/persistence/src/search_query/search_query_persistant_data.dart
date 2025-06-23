import 'package:flutter/material.dart';

@immutable
class SearchQueryPersistentData {
  const SearchQueryPersistentData({
    required this.query,
  });

  final String query;

  static SearchQueryPersistentData fromJson(dynamic json) {
    if (json case {
      'query': final String query,
    }) {
      return SearchQueryPersistentData(
        query: query,
      );
    } else {
      throw const FormatException('Invalid SearchQueryPersistentData format');
    }
  }

  dynamic toJson() {
    final map = <String, dynamic>{
      'query': query,
    };
    return map;
  }
}
