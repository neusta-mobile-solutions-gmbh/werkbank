/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
/// @docImport 'package:werkbank/src/addon_config/addon_config.dart';
/// @docImport 'package:werkbank/src/persistence/persistence.dart';
/// @docImport 'package:werkbank/src/widgets/widgets.dart';
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
  ///
  /// An [onUpdate] function can be passed to update the controller when the
  /// environment where the controller is registered has changed.
  /// This is typically happens every time the [register] function itself
  /// is called.
  /// In the case where the controller are registered by an [Addon] in the
  /// [Addon.registerGlobalStateControllers] this, both this [register] method
  /// and the [onUpdate] callback are called when the [AddonConfig] passed
  /// to the [WerkbankApp] or [DisplayApp] changes.
  /// This means the [onUpdate] callback is a good place to inform
  /// the controller about changes to the [Addon] in which it was registered.
  void register<T extends GlobalStateController>(
    String id,
    T Function() createController, {
    void Function(T controller)? onUpdate,
  });
}
