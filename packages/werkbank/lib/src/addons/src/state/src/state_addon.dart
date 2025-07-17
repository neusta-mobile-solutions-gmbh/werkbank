import 'package:werkbank/src/addons/src/state/src/_internal/immutable/state_containers_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_management_state_entry.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/mutable/mutable_state_retainment_state_entry.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
/// {@category State}
class StateAddon extends Addon {
  const StateAddon() : super(id: addonId);

  static const addonId = 'state';

  @override
  List<AnyTransientUseCaseStateEntry> createTransientUseCaseStateEntries() => [
    StateContainersStateEntry(),
    MutableStateManagementStateEntry(),
  ];

  @override
  List<AnyRetainedUseCaseStateEntry> createRetainedUseCaseStateEntries() => [
    MutableStateRetainmentStateEntry(),
  ];
}
