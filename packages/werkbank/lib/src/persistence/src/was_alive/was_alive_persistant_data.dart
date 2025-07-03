import 'package:flutter/material.dart';

@immutable
class WasAlivePersistentData {
  const WasAlivePersistentData({
    required this.appWasAlive,
  });

  // This time will not be updated every second, just
  // every few seconds to not waste resources.
  // Keep that in mind when using this value
  final DateTime appWasAlive;

  static WasAlivePersistentData fromJson(Object? json) {
    if (json case {'appWasAlive': final String appWasAlive}) {
      return WasAlivePersistentData(
        appWasAlive: DateTime.parse(appWasAlive),
      );
    } else {
      throw const FormatException('Invalid WasAlivePersistentData format');
    }
  }

  dynamic toJson() {
    return {
      'appWasAlive': appWasAlive.toIso8601String(),
    };
  }
}
