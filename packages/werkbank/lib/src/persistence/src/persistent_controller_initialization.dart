import 'package:werkbank/src/persistence/persistence.dart';

/// A typedef for any [GlobalStateInitialization] regardless of its
/// generic type.
typedef AnyGlobalStateInitialization =
    GlobalStateInitialization<GlobalStateController>;

class GlobalStateInitialization<T extends GlobalStateController> {
  GlobalStateInitialization(this.initialize);

  final void Function(T controller) initialize;

  // TODO: improve this.
  bool tryInitialize(
    GlobalStateController controller,
  ) {
    if (controller is T) {
      initialize(controller);
      return true;
    }
    return false;
  }
}
