import 'package:werkbank/src/persistence/src/persistent_controller.dart';

abstract class GlobalStateControllerRegistry {
  void register<T extends GlobalStateController>(
    String id,
    T Function() createController,
  );
}
