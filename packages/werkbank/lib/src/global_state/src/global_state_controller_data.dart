import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/persistence/persistence.dart';

// TODO: document
class GlobalStateControllerData {
  GlobalStateControllerData({
    required this.jsonStore,
    required this.globalState,
    required this.isWarmStart,
  });

  final JsonStore jsonStore;
  final GlobalState globalState;
  final bool isWarmStart;
}
