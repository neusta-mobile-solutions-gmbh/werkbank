/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/werkbank_app_global_state/werkbank_app_global_state.dart';

/// A type to access all [GlobalStateController]s for a [WerkbankApp].
extension type WerkbankAppGlobalState(GlobalState _globalState) {
  /// Returns the [HistoryController] used by the current [WerkbankApp].
  HistoryController get history => _globalState.get<HistoryController>();

  /// Returns the [SearchQueryController] used by the current [WerkbankApp].
  SearchQueryController get searchQuery =>
      _globalState.get<SearchQueryController>();

  /// Returns the [SectionsController] used by the current [WerkbankApp].
  SectionsController get sections => _globalState.get<SectionsController>();

  /// Returns the [PanelTabController] used by the current [WerkbankApp].
  PanelTabController get panelTab => _globalState.get<PanelTabController>();

  /// Returns the [PanelController] used by the current [WerkbankApp].
  PanelController get panel => _globalState.get<PanelController>();
}

extension WerkbankAppGlobalStateExtension on GlobalState {
  /// {@template werkbank.werkbank_app_global_state_extension.werkbankApp}
  /// Gets an object that provides access to all
  /// [GlobalStateController]s that are available inside a [WerkbankApp].
  /// {@endtemplate}
  ///
  /// If we are not running inside a [WerkbankApp], this throws a [StateError].
  WerkbankAppGlobalState get werkbankApp =>
      maybeWerkbankApp ??
      (throw StateError(
        'Cannot access the global state for a WerkbankApp, because we are not '
        'running inside a WerkbankApp. '
        'Consider using `maybeWerkbankApp` instead and handle the `null` case.',
      ));

  /// {@macro werkbank.werkbank_app_global_state_extension.werkbankApp}
  WerkbankAppGlobalState? get maybeWerkbankApp {
    // We use the presence of SearchQueryController, because it is
    // present if and only if we are running inside a WerkbankApp.
    if (maybeGet<SearchQueryController>() != null) {
      return WerkbankAppGlobalState(this);
    }
    return null;
  }
}
