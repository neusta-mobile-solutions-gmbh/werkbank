import 'package:flutter/material.dart';

class NotificationController extends ChangeNotifier
    implements NotificationSubscription {
  NotificationController(
    WerkbankNotification notification, {
    required FullAccessNotificationsController parent,
    required TickerProvider vsync,
    required this.firstDispatchTime,
    this.dispatchedCount = 1,
  }) : _notification = notification,
       _parentController = parent,
       _status = NotificationStatus.visible,
       _visibilityController = notification.dismissAfter != null
           ? AnimationController(
               duration: notification.dismissAfter,
               vsync: vsync,
             )
           : null,
       _dismissController = AnimationController(
         duration: NotificationSubscription.dismissDuration,
         vsync: vsync,
       ) {
    _visibilityController?.forward();
    _visibilityController?.addListener(_onVisibilityChanged);
  }

  final FullAccessNotificationsController _parentController;

  AnimationController? _visibilityController;
  final AnimationController _dismissController;

  NotificationStatus _status;

  @override
  NotificationStatus get status => _status;

  @override
  bool get disposed => _status == NotificationStatus.disposed;

  @override
  final DateTime firstDispatchTime;

  @override
  final int dispatchedCount;

  WerkbankNotification? _notification;

  @override
  WerkbankNotification get notification {
    assert(
      _status != NotificationStatus.disposed,
      'Tried to access a disposed notification.',
    );
    return _notification!;
  }

  set notification(WerkbankNotification notification) {
    assert(
      _status != NotificationStatus.disposed,
      'Tried to access a disposed notification.',
    );
    assert(
      notification.key == _notification!.key,
      'Tried to change the id of a notification.',
    );

    _notification = notification;
    notifyListeners();
  }

  void _onVisibilityChanged() {
    if (_visibilityController!.status == AnimationStatus.completed) {
      dismiss();
    }
  }

  @override
  void dismiss({bool notify = true}) {
    if ([
      NotificationStatus.dismissed,
      NotificationStatus.disposed,
    ].contains(_status)) {
      // Was already dismissed or even disposed
      // Calling it again is not a severe issue,
      // but it's a misuse of the API.
      return;
    }

    _dismissController
      ..forward()
      ..addListener(_onDismissControllerChange);
    _status = NotificationStatus.dismissed;
    if (notify) {
      notifyListeners();
    }
  }

  void _onDismissControllerChange() {
    if (_dismissController.status == AnimationStatus.completed) {
      dispose();
    }
  }

  @override
  void dispose() {
    final key = _notification!.key;
    _status = NotificationStatus.disposed;
    _parentController.disposeNotification(key);
    _notification = null;
    _visibilityController?.dispose();
    _dismissController.dispose();
    notifyListeners();
    super.dispose();
  }

  @override
  void resumeVisibility() {
    if (status != NotificationStatus.visible) {
      return;
    }
    if (_visibilityController?.status == AnimationStatus.reverse) {
      return;
    }

    _visibilityController?.forward();
  }

  @override
  void pauseVisibility() {
    if (status != NotificationStatus.visible) {
      return;
    }

    _visibilityController?.stop();
  }

  @override
  void keepVisible() {
    if (status != NotificationStatus.visible) {
      return;
    }
    _visibilityController?.stop();
    _visibilityController?.duration = Durations.medium1;
    _visibilityController?.reverse();
    _visibilityController?.addListener(_onReverseDone);
  }

  void _onReverseDone() {
    final reverseDone =
        _visibilityController?.status == AnimationStatus.dismissed;
    if (reverseDone) {
      _visibilityController?.dispose();
      _visibilityController = null;
      notifyListeners();
    }
  }

  @override
  Animation<double>? get visibilityAnimation => _visibilityController?.view;

  @override
  Animation<double> get dismissAnimation => _dismissController.view;
}
