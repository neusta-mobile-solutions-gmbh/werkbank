import 'package:werkbank/src/persistence/persistence.dart';

/// A typedef for any [PersistentControllerInitialization] regardless of its
/// generic type.
typedef AnyPersistentControllerInitialization =
    _Self<PersistentControllerInitialization<Object?>>;

// This is a workaround for a dart bug.
// For some reason the type cannot be declared directly as a typedef.
typedef _Self<T> = T;

class PersistentControllerInitialization<T extends PersistentController<T>> {
  PersistentControllerInitialization(this.initialize);

  final void Function(T controller) initialize;

  bool tryInitialize(
    AnyPersistentController controller,
  ) {
    if (controller is T) {
      initialize(controller);
      return true;
    }
    return false;
  }
}
