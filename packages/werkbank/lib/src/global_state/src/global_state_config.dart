/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
/// @docImport 'package:werkbank/src/addons/addons.dart';
/// @docImport 'package:werkbank/src/persistence/persistence.dart';
/// @docImport 'package:werkbank/src/werkbank_app_global_state/werkbank_app_global_state.dart';
/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:werkbank/src/global_state/global_state.dart';

// TODO: Add more places where global state is used.
/// An object containing configuration for the global state.
///
/// The most common use is to initialize the global state of a
/// [DisplayApp] at startup.
/// For example this can be use to set the theme (of the [ThemingAddon]),
/// locale (of the [LocalizationAddon]) or similar
/// when using the [DisplayApp] in tests.
///
/// [Addon]s and Werkbank itself use [GlobalStateController]s to manage
/// and persist state that is shared across the whole application.
/// This includes things like:
/// - The order and expansion state of the sections in the right panel.
/// - The selected Werkbank theme.
///
/// The [initialize] function can be used to change
/// this global state at startup.
class GlobalStateConfig {
  const GlobalStateConfig({
    this.initialize,
    this.alwaysTreatLikeWarmStart = false,
  });

  /// A function that is called on startup with a
  /// [GlobalState] that can be used to
  /// get access to the registered [GlobalStateController]s and
  /// change their initial state.
  ///
  /// This is especially useful to bring a [DisplayApp] into a certain state,
  /// since it uses a [PersistenceConfig.memory] by default and thus
  /// does not persist any state across restarts.
  ///
  /// This is not intended for initializing a [GlobalStateController] itself to
  /// get it into a valid state.
  /// That should be in the `onUpdate` parameter of the
  /// [GlobalStateControllerRegistry.register] function that you call when
  /// registering the controller in the
  /// [Addon.registerGlobalStateControllers] method.
  final void Function(GlobalState globalState)? initialize;

  /// If true, the [GlobalStateController] will always have their
  /// [GlobalStateController.tryLoadFromJson] called with
  /// `isWarmStart` set to `true` on startup.
  ///
  /// A warm start is when the app is restarted right after it was closed,
  /// for example on a hot restart.
  ///
  /// Some [GlobalStateController]s may choose to not load some state on a cold
  /// start.
  /// An example of this is the [SearchQueryController], which does not load
  /// the previous search query on a cold start, because the user likely
  /// expects a fresh state then.
  final bool alwaysTreatLikeWarmStart;
}
