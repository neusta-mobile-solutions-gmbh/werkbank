import 'package:werkbank/src/global_state/global_state.dart';

abstract class GlobalStateControllerRegistry {
  void register<T extends GlobalStateController>(
    String id,
    T Function() createController,
  );
}
