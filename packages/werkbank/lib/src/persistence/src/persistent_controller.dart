import 'package:flutter/material.dart';

/// A typedef for any [PersistentController] regardless of its generic
/// type.
typedef AnyPersistentController = _Self<PersistentController<Object?>>;

// This is a workaround for a dart bug.
// For some reason the type cannot be declared directly as a typedef.
typedef _Self<T> = T;

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
