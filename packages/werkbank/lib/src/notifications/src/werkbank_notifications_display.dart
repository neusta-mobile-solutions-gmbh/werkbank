import 'package:flutter/material.dart';

class WerkbankNotificationsDisplay extends StatefulWidget {
  const WerkbankNotificationsDisplay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<WerkbankNotificationsDisplay> createState() =>
      _WerkbankNotificationsDisplayState();
}

class _WerkbankNotificationsDisplayState
    extends State<WerkbankNotificationsDisplay> {
  late NotificationsController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = WerkbankNotifications.controllerOf(context);
  }

  @override
  Widget build(BuildContext context) {
    const vertical = 8.0;
    const horizontal = 8.0;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: vertical),
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final sortedEntries =
                    (controller.notificationSubscriptionMap.entries.toList(
                      growable: false,
                    )..sort(
                      (a, b) => b.value.firstDispatchTime.compareTo(
                        a.value.firstDispatchTime,
                      ),
                    ));
                return Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final (entry) in sortedEntries)
                          KeyedSubtree(
                            key: ValueKey(entry.key),
                            child: WNotificationInAndOut(
                              dismissAnimation: entry.value.dismissAnimation,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: entry.key == sortedEntries.first.key
                                      ? 0
                                      : 8,
                                ),
                                child: WDraggableConstrainedBox(
                                  leftRight: const DraggableBorders(
                                    initialMaxValue: 400,
                                    enableStartBorder: true,
                                    minDraggableValue: 200,
                                    // ignore: avoid_redundant_argument_values
                                    thickness: horizontal,
                                  ),
                                  child: ListenableBuilder(
                                    listenable: entry.value,
                                    builder: (context, _) {
                                      final notification =
                                          entry.value.notification;
                                      return WNotification(
                                        counter: entry.value.dispatchedCount > 1
                                            ? entry.value.dispatchedCount
                                            : null,
                                        notification: notification,
                                        onDismiss: entry.value.dismiss,
                                        onContinueVisibility:
                                            entry.value.resumeVisibility,
                                        onKeepVisible: entry.value.keepVisible,
                                        onPauseVisibility:
                                            entry.value.pauseVisibility,
                                        visibilityAnimation:
                                            entry.value.visibilityAnimation,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
