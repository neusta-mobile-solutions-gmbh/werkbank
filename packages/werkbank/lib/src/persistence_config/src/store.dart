import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class JsonStore {
  void set(String key, Object? json);

  Object? get(String key);
}

class MemoryStore implements JsonStore {
  final Map<String, Object?> _store = {};

  @override
  void set(String key, Object? json) {
    if (json == null) {
      _store.remove(key);
      return;
    }
    _store[key] = json;
  }

  @override
  Object? get(String key) {
    return _store[key];
  }
}

class SharedPreferencesStore implements JsonStore {
  SharedPreferencesStore(this._sharedPrefs);

  final SharedPreferencesWithCache _sharedPrefs;

  @override
  void set(String key, Object? json) {
    if (json == null) {
      _sharedPrefs.remove(key);
      return;
    }
    final jsonString = jsonEncode(json);
    _sharedPrefs.setString(key, jsonString);
  }

  @override
  Object? get(String key) {
    final jsonString = _sharedPrefs.getString(key);
    if (jsonString == null) {
      return null;
    }
    return json.decode(jsonString);
  }
}
