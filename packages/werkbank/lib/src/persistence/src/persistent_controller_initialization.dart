import 'package:werkbank/src/persistence/persistence.dart';

/// A typedef for any [PersistentControllerInitialization] regardless of its
/// generic type.
typedef AnyPersistentControllerInitialization =
    PersistentControllerInitialization<PersistentController>;

class PersistentControllerInitialization<T extends PersistentController> {
  PersistentControllerInitialization(this.initialize);

  final void Function(T controller) initialize;

  bool tryInitialize(
    PersistentController controller,
  ) {
    if (controller is T) {
      initialize(controller);
      return true;
    }
    return false;
  }
}
