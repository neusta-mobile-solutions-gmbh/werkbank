import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class WasAliveController extends PersistentController<WasAliveController> {
  WasAliveController() : super(id: 'was_alive');

  @override
  void tryLoadFromJson(Object? json) {
    try {
      _persistentData = WasAlivePersistentData.fromJson(json);
      _isColdAppStart = !appWasAliveRecently;
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
  late bool _isColdAppStart = true;

  /// If this was a regular app start, this will be set to true.
  /// Else if this was just a restart of the app, this will be false.
  ///
  /// It will only be set once per app start.
  bool get isColdAppStart {
    return _isColdAppStart;
  }

  /// Usually this is true.
  /// Just for the first frame of an app start, this will be false,
  /// if the app was not running in the last 30 seconds.
  bool get appWasAliveRecently {
    final result =
        DateTime.now().difference(_persistentData.appWasAlive).inSeconds < 30;
    return result;
  }

  void logAppIsAlive() {
    _persistentData = WasAlivePersistentData(
      appWasAlive: DateTime.now(),
    );
    notifyListeners();
  }
}
