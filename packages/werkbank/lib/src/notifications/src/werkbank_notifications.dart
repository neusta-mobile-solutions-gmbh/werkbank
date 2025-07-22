import 'package:flutter/material.dart';

class WerkbankNotifications extends StatefulWidget {
  const WerkbankNotifications({
    required this.child,
    super.key,
  });

  final Widget child;

  static NotificationSubscription dispatch(
    BuildContext context,
    WerkbankNotification notification,
  ) {
    return controllerOf(context).dispatch(notification);
  }

  static NotificationSubscription? notificationOf(
    BuildContext context, {
    required LocalKey key,
  }) {
    return controllerOf(context).getNotificationSubscriptionByKey(key: key);
  }

  static NotificationsController controllerOf(BuildContext context) {
    final inheritedWidget = context
        .dependOnInheritedWidgetOfExactType<_InheritedNotifications>();
    if (inheritedWidget == null) {
      throw Exception('No NotificationsController found in context');
    }

    return inheritedWidget.controller;
  }

  @override
  State<WerkbankNotifications> createState() => _WerkbankNotificationsState();
}

class _WerkbankNotificationsState extends State<WerkbankNotifications>
    with TickerProviderStateMixin {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = FullAccessNotificationsController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedNotifications(
      controller: controller,
      child: widget.child,
    );
  }
}

class _InheritedNotifications extends InheritedWidget {
  const _InheritedNotifications({
    required this.controller,
    required super.child,
  });

  final NotificationsController controller;

  @override
  bool updateShouldNotify(covariant _InheritedNotifications oldWidget) {
    return controller != oldWidget.controller;
  }
}
