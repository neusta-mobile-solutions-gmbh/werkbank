/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:werkbank/src/global_state/global_state.dart';

/// An object that provides access to all [GlobalStateController]s that
/// have been registered, either by addons or by the [WerkbankApp] itself.
///
/// The [get] and [maybeGet] methods can be used to retrieve
/// a registered [GlobalStateController] by its type.
///
/// Addon authors should consider creating an extension on this class
/// that add convenience getters for their own [GlobalStateController]s.
abstract class GlobalState {
  /// {@template werkbank.global_state_locator.get}
  /// Returns the [GlobalStateController] with the given type [T] that was
  /// registered in the [GlobalStateControllerRegistry].
  /// {@endtemplate}
  T get<T extends GlobalStateController>() {
    final controller = maybeGet<T>();
    if (controller == null) {
      throw StateError(
        'No GlobalStateController of type $T was registered in the '
        'GlobalStateControllerRegistry.',
      );
    }
    return controller;
  }

  /// {@macro werkbank.global_state_locator.get}
  ///
  /// If no controller of type [T] was registered, returns `null`.
  T? maybeGet<T extends GlobalStateController>();
}
