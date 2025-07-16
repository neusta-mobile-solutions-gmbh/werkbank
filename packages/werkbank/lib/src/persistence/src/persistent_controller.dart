import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistentController<T extends PersistentController<T>>
    extends ChangeNotifier {
  PersistentController({
    required this.id,
  });

  /// A string that uniquely identifies
  /// this controller and its persisted storage.
  final String id;

  Type get type => T;

  void tryLoadFromJson(Object? json);

  Object? toJson();
}
