/// @docImport 'package:werkbank/src/addon_api/addon_api.dart';
/// @docImport 'package:werkbank/src/persistence/persistence.dart';
/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:werkbank/src/global_state/global_state.dart';

// TODO: Add more places where global state is used.
/// A configuration object containing global state [initializations].
///
/// [Addon]s and Werkbank itself use [GlobalStateController]s to manage
/// and persist state that is shared across the whole application.
/// This includes things like:
/// - The order and expansion state of the sections in the right panel.
/// - The selected Werkbank theme.
///
/// The [initializations] can be used to change this global state at
/// startup.
/// This is especially useful to bring a [DisplayApp] into a certain state,
/// since it uses a [PersistenceConfig.memory] by default and thus
/// does not persist any state across restarts.
class GlobalStateConfig {
  const GlobalStateConfig({
    this.initializations = const [],
  });

  // TODO: Check if this works with type inference.
  final List<AnyGlobalStateInitialization> initializations;
}
