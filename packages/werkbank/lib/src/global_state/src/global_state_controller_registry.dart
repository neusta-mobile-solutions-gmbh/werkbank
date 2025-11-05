/// @docImport 'package:werkbank/src/persistence/persistence.dart';
library;

import 'package:werkbank/src/global_state/global_state.dart';

abstract class GlobalStateControllerRegistry {
  /// Registers a [GlobalStateController] for the given type [T].
  ///
  /// The [id] is use as a key to store the json produced by the controller's
  /// [GlobalStateController.toJson] method in the [JsonStore] defined by the
  /// used [PersistenceConfig].
  ///
  /// The [createController] function is used to create an instance of the
  /// controller.
  /// Even though this [register] function can be called multiple times in
  /// order to check if a new controller needs to be created for
  /// the given type [T], the [createController] function will only be called
  /// once and the controller is kept alive for the lifetime of the application.
  void register<T extends GlobalStateController>(
    String id,
    T Function() createController,
  );
}
