import 'package:werkbank/src/persistence/src/persistent_controller.dart';

abstract class PersistentControllerRegistry {
  void register<T extends PersistentController>(
    String id,
    T Function() createController,
  );
}
