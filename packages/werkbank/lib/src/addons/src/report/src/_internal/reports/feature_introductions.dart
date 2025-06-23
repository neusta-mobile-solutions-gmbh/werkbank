import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

List<Report> get featureIntroductions => [
  NewContentReport(
    id: 'notifications_1',
    title: '🎉🥳 Notifications 🥳🎉',
    publishDate: DateTime(2025, 2),
    sortHint: const SortHint(-1999),
    content: const _NotificationsIntroduction(),
  ),
];

class _NotificationsIntroduction extends StatefulWidget {
  const _NotificationsIntroduction();

  @override
  State<_NotificationsIntroduction> createState() =>
      _NotificationsIntroductionState();
}

class _NotificationsIntroductionState
    extends State<_NotificationsIntroduction> {
  bool switchValue = false;
  List<NotificationSubscription> notificationSubscriptions = [];

  @override
  void dispose() {
    for (final sub in notificationSubscriptions) {
      if (!sub.disposed) {
        sub.dismiss(notify: false);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const WMarkdown(
          data: '''
Werkbank now supports notifications! This feature allows you to display real-time alerts '
'and messages directly within the app. Use it to show important information, including the app-state or errors.'
''',
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            runSpacing: 16,
            spacing: 16,
            children: [
              WChip(
                isActive: true,
                onPressed: () {
                  notificationSubscriptions.add(
                    WerkbankNotifications.dispatch(
                      context,
                      WerkbankNotification.text(
                        title: "Isn't this useful?",
                        content:
                            'You can now add detailed content to your '
                            'notifications for a comprehensive explanation. ',
                        source: 'Introducing Notifications',
                      ),
                    ),
                  );
                },
                label: const Text('Take a look'),
              ),
              WChip(
                isActive: true,
                onPressed: () {
                  notificationSubscriptions.add(
                    WerkbankNotifications.dispatch(
                      context,
                      WerkbankNotification.text(
                        title:
                            'Customize the width of your notifications '
                            'by simply dragging. ',
                      ),
                    ),
                  );
                },
                label: const Text('1'),
              ),
              WChip(
                isActive: true,
                onPressed: () {
                  notificationSubscriptions.add(
                    WerkbankNotifications.dispatch(
                      context,
                      WerkbankNotification.text(
                        title:
                            'This notification will remain '
                            'until you dismiss it '
                            'manually, ensuring you never miss critical '
                            'information.',
                        dismissAfter: null,
                      ),
                    ),
                  );
                },
                label: const Text('2'),
              ),
              WChip(
                isActive: true,
                onPressed: () {
                  notificationSubscriptions.add(
                    WerkbankNotifications.dispatch(
                      context,
                      WerkbankNotification.widgets(
                        key: const ValueKey('switch_notifications'),
                        buildHead: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WSwitch(
                              value: switchValue,
                              onChanged: (v) {
                                setState(() {
                                  switchValue = v;
                                });
                                notificationSubscriptions.add(
                                  WerkbankNotifications.dispatch(
                                    context,
                                    WerkbankNotification.text(
                                      title: switchValue ? 'on' : 'off',
                                    ),
                                  ),
                                );
                              },
                              falseLabel: const Text('There are'),
                              trueLabel: const Text('no limits'),
                            ),
                            const SizedBox(height: 16),
                            const Text('to what you can use this for'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                label: const Text('3'),
              ),
            ],
          ),
        ),
        const WMarkdown(
          data: '''
Dispatch notifications effortlessly using the following code snippet:
```dart
UseCase.dispatchNotification(context, notification);
```
Integrate this within your use case today.
            ''',
        ),
      ],
    );
  }
}
