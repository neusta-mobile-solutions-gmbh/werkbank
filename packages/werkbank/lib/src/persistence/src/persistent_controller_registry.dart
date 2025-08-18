import 'package:werkbank/src/persistence/src/persistent_controller.dart';

abstract class PersistentControllerRegistry {
  void register(
    String id,
    AnyPersistentController Function() createController,
  );
}
