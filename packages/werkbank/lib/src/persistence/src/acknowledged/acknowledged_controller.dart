import 'package:werkbank/src/werkbank_internal.dart';

abstract class AcknowledgedController
    implements PersistentController<AcknowledgedController> {
  AcknowledgedController();

  AcknowledgedDescriptors get descriptors;

  void log(String path);

  // Clearing is more like resetting for this feature.
}
