import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:werkbank/src/persistence/src/persistent_controller.dart';
import 'package:werkbank/src/persistence/src/was_alive/was_alive_persistant_data.dart';

class WasAliveController extends PersistentController {
  WasAliveController({
    required super.prefsWithCache,
  });

  @override
  String get id => 'was_alive';

  @override
  void init(String? unsafeJson) {
    late final fallback = WasAlivePersistentData(
      appWasAlive: DateTime.now(),
    );

    try {
      _persistentData = unsafeJson != null
          ? WasAlivePersistentData.fromJson(jsonDecode(unsafeJson))
          : fallback;
      _isColdAppStart = !appWasAliveRecently;
    } on FormatException {
      debugPrint(
        'Restoring WasAlivePersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
      _persistentData = fallback;
      _isColdAppStart = true;
    }
  }

  late WasAlivePersistentData _persistentData;
  late bool _isColdAppStart;

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
    _update();
  }

  void _update() {
    setJson(jsonEncode(_persistentData.toJson()));
    notifyListeners();
  }
}
