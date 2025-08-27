import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class WerkbankNotification with EquatableMixin {
  const WerkbankNotification({
    required this.key,
    required this.source,
    required this.dismissAfter,
  });

  /// Creates a [WerkbankNotification] using [title] and [content] [String]s.
  ///
  /// The [key] is optional. If not provided, a key will be generated
  /// from the [title] and [content].
  ///
  /// {@template werkbank.notification_id}
  /// The [key] is used to identify the notification. In case it
  /// gets dispatched multiple times,
  /// the notification will be updated instead of creating new ones.
  /// {@endtemplate}
  factory WerkbankNotification.text({
    required String title,
    String? content,
    LocalKey? key,
    String? source,
    Duration? dismissAfter = const Duration(seconds: 2),
  }) => _WerkbankTextNotification._(
    title: title,
    content: content,
    key: key ?? ValueKey('${title}_$content'),
    source: source,
    dismissAfter: dismissAfter,
  );

  /// Creates a [WerkbankNotification] using [buildHead] and [buildBody]
  /// [WidgetBuilder]s.
  ///
  /// {@macro werkbank.notification_id}
  /// If you dont care about the notification being identified,
  /// use a [UniqueKey].
  factory WerkbankNotification.widgets({
    required WidgetBuilder buildHead,
    WidgetBuilder? buildBody,
    required LocalKey key,
    String? source,
    Duration? dismissAfter = const Duration(seconds: 2),
  }) => _WerkbankWidgetsNotification._(
    head: buildHead,
    body: buildBody,
    key: key,
    source: source,
    dismissAfter: dismissAfter,
  );

  /// {@macro werkbank.notification_id}
  final LocalKey key;
  final String? source;
  final Duration? dismissAfter;

  Widget buildHead(BuildContext context);
  Widget? buildBody(BuildContext context);
}

class _WerkbankTextNotification extends WerkbankNotification {
  const _WerkbankTextNotification._({
    required super.key,
    required super.source,
    required super.dismissAfter,
    required this.title,
    required this.content,
  });

  final String title;
  final String? content;

  @override
  List<Object?> get props => [
    key,
    source,
    dismissAfter,
    title,
    content,
  ];

  @override
  Widget buildHead(BuildContext context) => Text(title);

  @override
  Widget? buildBody(BuildContext context) =>
      content != null ? Text(content!) : null;
}

class _WerkbankWidgetsNotification extends WerkbankNotification {
  const _WerkbankWidgetsNotification._({
    required super.key,
    required super.dismissAfter,
    required super.source,
    required this.head,
    required this.body,
  });

  final WidgetBuilder head;
  final WidgetBuilder? body;

  @override
  List<Object?> get props => [
    key,
    dismissAfter,
    source,
    head,
    body,
  ];

  @override
  Widget buildHead(BuildContext context) => head(context);

  @override
  Widget? buildBody(BuildContext context) => body?.call(context);
}
