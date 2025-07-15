import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistentController extends ChangeNotifier {
  PersistentController({
    required SharedPreferencesWithCache prefsWithCache,
  }) : _prefsWithCache = prefsWithCache {
    final json = _prefsWithCache.getString(id);
    init(json);
  }

  void init(String? unsafeJson);

  final SharedPreferencesWithCache _prefsWithCache;

  /// A string that uniquely identifies
  /// this controller and its persisted storage.
  String get id;

  void setJson(String json) {
    unawaited(_prefsWithCache.setString(id, json));
  }

  void clear() {
    unawaited(_prefsWithCache.remove(id));
    notifyListeners();
  }
}
