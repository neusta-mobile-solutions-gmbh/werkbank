import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class OverviewOverflowNotifier extends StatefulWidget {
  const OverviewOverflowNotifier({super.key, required this.child});

  final Widget child;

  @override
  State<OverviewOverflowNotifier> createState() =>
      _OverviewOverflowNotifierState();
}

class _OverviewOverflowNotifierState extends State<OverviewOverflowNotifier> {
  static final _overflowRegex = RegExp(r'A .* overflowed by .*\.$');

  StreamSubscription<FlutterErrorDetails>? _errorSubscription;
  NotificationSubscription? _sub;
  late bool usesConstraintsAddon;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _errorSubscription ??= FlutterErrorProvider.listen(context, _onError);
    usesConstraintsAddon = AddonSpecificationsProvider.of(
      context,
    ).containsKey(ConstraintsAddon.addonId);
  }

  void _onError(FlutterErrorDetails details) {
    if (!kDebugMode) {
      return;
    }
    if (details.library != 'rendering library') {
      return;
    }
    final exception = details.exception;
    if (exception is! FlutterError) {
      return;
    }
    if (_overflowRegex.matchAsPrefix(exception.message) == null) {
      return;
    }
    _sub = WerkbankNotifications.controllerOf(context).dispatch(
      WerkbankNotification.widgets(
        key: const ValueKey('overflow_notification'),
        buildHead: (context) => Text(
          context.sL10n.overview.overflow_notification.title,
          overflow: TextOverflow.ellipsis,
        ),
        buildBody: (context) => WMarkdown(
          data: usesConstraintsAddon
              ? context
                    .sL10n
                    .overview
                    .overflow_notification
                    .contentWithConstraintsAddonMarkdown
              : context.sL10n.overview.overflow_notification.contentMarkdown,
        ),
        dismissAfter: null,
      ),
      count: false,
    );
  }

  @override
  void dispose() {
    unawaited(_errorSubscription?.cancel());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_sub?.status == NotificationStatus.visible) {
        _sub?.dismiss();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
