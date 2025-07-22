import 'package:flutter/material.dart';

// TODO(lzuttermeister): Change this to a widget?
class UseCase {
  /// Gets the [UseCaseMetadata] of the current use case.
  static UseCaseMetadata metaDataOf(BuildContext context) {
    return UseCaseCompositionProvider.metadataOf(context);
  }

  /// Gets the [UseCaseComposition] of the current use case.
  static UseCaseComposition compositionOf(BuildContext context) {
    return UseCaseCompositionProvider.compositionOf(context);
  }

  /// Dispatches a [WerkbankNotification] constructed using the
  /// [notificationTitle].
  static NotificationSubscription dispatchTextNotification(
    BuildContext context,
    String notificationTitle, {
    bool count = true,
  }) {
    return WerkbankNotifications.controllerOf(context).dispatch(
      WerkbankNotification.text(
        title: notificationTitle,
      ),
      count: count,
    );
  }

  /// Dispatches a [WerkbankNotification].
  static NotificationSubscription dispatchNotification(
    BuildContext context,
    WerkbankNotification notification, {
    bool count = true,
  }) {
    return WerkbankNotifications.controllerOf(context).dispatch(
      notification,
      count: count,
    );
  }

  /// Gets the [WerkbankNotification] of the given [key].
  static NotificationSubscription? notificationOf(
    BuildContext context, {
    required LocalKey key,
  }) {
    return WerkbankNotifications.controllerOf(
      context,
    ).getNotificationSubscriptionByKey(key: key);
  }

  /// Retrieves the [WerkbankEnvironment] in which the use case is displayed.
  static WerkbankEnvironment environmentOf(BuildContext context) {
    return WerkbankEnvironmentProvider.of(context);
  }

  /// Returns whether the current use case is shown as a thumbnail in the
  /// overview.
  /// This can be used to customize the thumbnail of a use case.
  static bool isInOverviewOf(BuildContext context) {
    return switch (UseCaseEnvironmentProvider.maybeOf(context)) {
      UseCaseEnvironment.overview => true,
      UseCaseEnvironment.regular => false,
      null => false,
    };
  }
}
