import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class WasAliveController extends PersistentController<WasAliveController> {
  WasAliveController() : super(id: 'was_alive');

  @override
  void tryLoadFromJson(Object? json) {
    try {
      _persistentData = WasAlivePersistentData.fromJson(json);
    } on FormatException {
      debugPrint(
        'Restoring WasAlivePersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
    }
  }

  @override
  Object? toJson() {
    return _persistentData.toJson();
  }

  late WasAlivePersistentData _persistentData = WasAlivePersistentData(
    appWasAlive: DateTime.now(),
  );

  // If the app was not alive recently, this will just be false
  // for the first frame of the app.
  // PostFrame, it will be set to true again.
  bool get appWasAliveRecently {
    final result =
        DateTime.now().difference(_persistentData.appWasAlive).inSeconds < 30;
    return result;
  }

  DateTime get appWasAliveDateTime => _persistentData.appWasAlive;

  void logAppIsAlive() {
    _persistentData = WasAlivePersistentData(
      appWasAlive: DateTime.now(),
    );
    notifyListeners();
  }
}
