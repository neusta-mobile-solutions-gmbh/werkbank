import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

abstract class NotificationsController implements ChangeNotifier {
  NotificationSubscription dispatch(
    WerkbankNotification notification, {
    bool count = true,
  });

  NotificationSubscription? getNotificationSubscriptionByKey({
    required LocalKey key,
  });

  IMap<LocalKey, NotificationSubscription> get notificationSubscriptionMap;

  @override
  void dispose();
}
