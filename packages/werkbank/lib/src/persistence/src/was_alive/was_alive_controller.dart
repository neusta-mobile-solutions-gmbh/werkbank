import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

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
    } on FormatException {
      debugPrint(
        'Restoring WasAlivePersistentData failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );
      _persistentData = fallback;
    }
  }

  late final FocusNode focusNode = FocusNode();

  late WasAlivePersistentData _persistentData;

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
    _update();
  }

  void _update() {
    setJson(jsonEncode(_persistentData.toJson()));
    notifyListeners();
  }
}
