import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/immutable/immutable_state_holders_state_entry.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/mutable/mutable_state_management_state_entry.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/mutable/mutable_state_retainment_state_entry.dart';
import 'package:werkbank/src/addons/src/state_keeping/src/_internal/mutable_state_ticker_provider_provider.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// {@category Configuring Addons}
/// {@category Keeping State}
class StateKeepingAddon extends Addon {
  const StateKeepingAddon() : super(id: addonId);

  static const addonId = 'state_keeping';

  @override
  AddonLayerEntries get layers => AddonLayerEntries(
    management: [
      ManagementLayerEntry(
        id: 'ticker_provider_provider',
        builder: (context, child) =>
            MutableStateTickerProviderProvider(child: child),
      ),
    ],
  );

  @override
  List<AnyTransientUseCaseStateEntry> createTransientUseCaseStateEntries() => [
    ImmutableStateHoldersStateEntry(),
    MutableStateManagementStateEntry(),
  ];

  @override
  List<AnyRetainedUseCaseStateEntry> createRetainedUseCaseStateEntries() => [
    MutableStateRetainmentStateEntry(),
  ];
}
