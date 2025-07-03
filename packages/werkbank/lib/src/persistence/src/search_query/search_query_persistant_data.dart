import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class SearchQueryPersistentData {
  const SearchQueryPersistentData({
    required this.query,
  });

  final String query;

  static SearchQueryPersistentData fromJson(Object? json) {
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

  Object? toJson() {
    return {
      'query': query,
    };
  }
}
