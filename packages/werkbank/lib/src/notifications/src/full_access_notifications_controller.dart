import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class FullAccessNotificationsController extends ChangeNotifier
    implements NotificationsController {
  FullAccessNotificationsController({
    required this.vsync,
  }) : _notifications = {};

  final TickerProvider vsync;

  final Map<LocalKey, NotificationController> _notifications;

  @override
  NotificationSubscription dispatch(
    WerkbankNotification notification, {
    bool count = true,
  }) {
    final key = notification.key;

    final updateExistingNotification = _notifications.containsKey(key);

    NotificationController notificationController;
    if (updateExistingNotification) {
      final oldNotificationController = _notifications[key]!;
      final newDispatchCount = !count
          ? oldNotificationController.dispatchedCount
          : oldNotificationController.dispatchedCount + 1;
      notificationController = NotificationController(
        notification,
        parent: this,
        vsync: vsync,
        dispatchedCount: newDispatchCount,
        firstDispatchTime: oldNotificationController.firstDispatchTime,
      );
      oldNotificationController.dispose();
      _notifications.remove(key);
      _notifications[key] = notificationController;
    } else {
      notificationController = NotificationController(
        notification,
        parent: this,
        vsync: vsync,
        firstDispatchTime: DateTime.now(),
      );
      _notifications[key] = notificationController;
    }

    notifyListeners();
    return notificationController;
  }

  @override
  NotificationSubscription? getNotificationSubscriptionByKey({
    required LocalKey key,
  }) {
    return _notifications[key];
  }

  @override
  IMap<LocalKey, NotificationSubscription> get notificationSubscriptionMap =>
      _notifications.lock;

  @override
  void dispose() {
    _notifications.clear();
    super.dispose();
  }

  void disposeNotification(LocalKey notificationKey) {
    _notifications.remove(notificationKey);
    notifyListeners();
  }
}
