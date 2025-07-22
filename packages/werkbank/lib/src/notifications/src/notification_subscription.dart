import 'package:flutter/material.dart';

abstract class NotificationSubscription implements Listenable {
  NotificationStatus get status;

  bool get disposed;

  WerkbankNotification get notification;

  int get dispatchedCount;

  Animation<double>? get visibilityAnimation;

  Animation<double> get dismissAnimation;

  DateTime get firstDispatchTime;

  void pauseVisibility();

  void resumeVisibility();

  void keepVisible();

  /// Depending on the Flutter Lifecycle you are facing,
  /// on dismissing, you might want to call it without triggering
  /// a rebuild, so you can set [notify] to `false`.
  /// For example, if you are in a dispose method, you might want to
  /// call `dismiss(notify: false)`.
  void dismiss({bool notify = true});

  static const dismissDuration = Durations.medium2;
}

enum NotificationStatus {
  // From the first moment the notification is dispatched, its status is
  visible,
  // When the notification is dismissed by the user or by the system,
  // its status changes to
  dismissed,
  // Then the notification-ui has time to animate out.
  // After [NotificationSubscription.dismissDuration] the notification is
  disposed,
  // and can no longer be accessed.
}
