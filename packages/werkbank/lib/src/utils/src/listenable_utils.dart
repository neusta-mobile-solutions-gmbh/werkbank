import 'package:flutter/foundation.dart';

extension SubscribableListenableExtension on Listenable {
  ListenableSubscription listen(VoidCallback listener) {
    addListener(listener);
    return ListenableSubscription._(() {
      removeListener(listener);
    });
  }
}

class ListenableSubscription {
  ListenableSubscription._(this._onCancel);

  final VoidCallback _onCancel;

  void cancel() {
    _onCancel();
  }
}
