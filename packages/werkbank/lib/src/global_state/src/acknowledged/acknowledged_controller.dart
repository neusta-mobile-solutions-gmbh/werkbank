import 'package:werkbank/src/global_state/global_state.dart';

abstract class AcknowledgedController implements GlobalStateController {
  AcknowledgedDescriptors get descriptors;

  void log(String path);

  // Clearing is more like resetting for this feature.
}
