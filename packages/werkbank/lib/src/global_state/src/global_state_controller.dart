/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
library;

import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: Summarize variant uses
/// A controller that manages and persists state that is global to
/// the whole application.
///
/// [Addon]s can create and register [GlobalStateController]s by overriding the
/// [Addon.registerGlobalStateControllers] method.
///
/// Also consider extending or mixing in one of the [GlobalStateController]
/// variants, such as:
/// - [ValueNotifierGlobalStateController]
/// - [PersistedGlobalStateControllerMixin]
/// - [SelfListeningPersistedGlobalStateControllerMixin]
/// - [NotifiablePersistedGlobalStateControllerMixin]
abstract class GlobalStateController {
  /* TODO: Should init have access to the GlobalState in the data?
       Makes it a bit inconsistent, since if a controller is added later,
       others that may have wanted to depend on it are not notified.
       Also you may access uninitialized controllers. */
  /// Initializes the [GlobalStateController] after it has been created
  /// and registered.
  /// The type parameter [C] is the type under which this
  /// [GlobalStateController] instance was registered.
  /// This type is unique among all registered [GlobalStateController]s.
  @mustCallSuper
  void init<C extends GlobalStateController>(
    GlobalStateControllerData data,
  ) {}

  @mustCallSuper
  void dispose() {}

  // TODO: Document super call requirement.
  /// Builds a widget that can supplement the functionality of the
  /// [GlobalStateController].
  ///
  /// The returned widget must wrap the [child] widget, which contains most of
  /// the werkbank application.
  /// The child will even contain widgets defined by [Addon]s
  /// in any [AddonLayer].
  ///
  /// The [child] must be built in a way that keeps its state when the
  /// [GlobalStateController] rebuilds it.
  ///
  /// The order in which the returned widgets of multiple
  /// [GlobalStateController]s are nested is arbitrary.
  /// So you should not rely on widgets from other [GlobalStateController]s
  /// being available in the widget tree.
  /// You can however access other [GlobalStateController]s themselves from
  /// the [GlobalStateControllerData] passed to this method.
  @mustCallSuper
  Widget build(
    BuildContext context,
    GlobalStateControllerData data,
    Widget child,
  ) => child;
}
