import 'package:werkbank/src/persistence/persistence.dart';

abstract class AcknowledgedController implements PersistentController {
  AcknowledgedController();

  AcknowledgedDescriptors get descriptors;

  void log(String path);

  // Clearing is more like resetting for this feature.
}
