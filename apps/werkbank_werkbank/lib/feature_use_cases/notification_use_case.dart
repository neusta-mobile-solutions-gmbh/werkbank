import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

// Default Constructors

WidgetBuilder notificationUseCase(UseCaseComposer c) {
  c
    ..tags([Tags.feature, Tags.notificationFeature])
    ..description(
      'Werkbank has a notification system that allows you '
      'to dispatch notifications. '
      'It can be used by the werkbank '
      'itself or by addons or by the user writing a use case.',
    );

  final title = c.knobs.string('title', initialValue: 'The Title');

  final randomTitle = c.knobs.boolean('Use random title', initialValue: false);

  final id = c.knobs.nullable.string(
    'id',
    initialValue: 'n_1',
    initiallyNull: true,
  );

  final withContent = c.knobs.boolean('With Content', initialValue: true);

  final dispatchCount = c.knobs.intSlider(
    'dispatch N times',
    initialValue: 1,
    max: 20,
  );

  final dismissAfterMs = c.knobs.nullable.intSlider(
    'DismissAfter (Milliseconds)',
    initialValue: 3000,
    max: 20000,
  );

  final count = c.knobs.boolean('Count', initialValue: true);

  return (context) {
    final notificationController = WerkbankNotifications.controllerOf(
      context,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: WChip(
                onPressed: () {
                  for (final _ in List.generate(
                    dispatchCount.value,
                    (index) => index,
                  )) {
                    WerkbankNotifications.controllerOf(context).dispatch(
                      WerkbankNotification.text(
                        key: ValueKey(id.value),
                        title: !randomTitle.value
                            ? title.value
                            : 'Random Title '
                                  '${Random().nextInt(1000)}',
                        content: withContent.value ? 'Content' : null,
                        dismissAfter: dismissAfterMs.value != null
                            ? Duration(milliseconds: dismissAfterMs.value!)
                            : null,
                      ),
                      count: count.value,
                    );
                  }
                },
                label: const Text('Dispatch Notification'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const WDivider.horizontal(),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: ListenableBuilder(
                listenable: notificationController,
                builder: (context, child) {
                  final notificationSubscriptionEntries = notificationController
                      .notificationSubscriptionMap
                      .entries;
                  return ListenableBuilder(
                    listenable: Listenable.merge(
                      notificationSubscriptionEntries.map((e) => e.value),
                    ),
                    builder: (context, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final nAEntry
                                in notificationSubscriptionEntries)
                              if (!nAEntry.value.disposed)
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    key: ValueKey(nAEntry.key),
                                    children: [
                                      WChip(
                                        onPressed: () {
                                          if (!nAEntry.value.disposed) {
                                            nAEntry.value.dismiss();
                                          }
                                        },
                                        label: const Text(
                                          'Dismiss Notification',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Status: '
                                          '${nAEntry.value.status}\n'
                                          'id: '
                                          '${nAEntry.value.notification.key}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  };
}
