import 'package:werkbank/src/persistence/src/acknowledged/acknowledged_descriptors.dart';
import 'package:werkbank/src/persistence/src/persistent_controller.dart';

abstract class AcknowledgedController implements PersistentController {
  AcknowledgedController();

  AcknowledgedDescriptors get descriptors;

  void log(String path);

  // Clearing is more like resetting for this feature.
}
