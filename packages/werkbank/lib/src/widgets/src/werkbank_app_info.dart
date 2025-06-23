import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class WerkbankAppInfo extends InheritedWidget {
  const WerkbankAppInfo({
    super.key,
    required this.name,
    required this.logo,
    required this.lastUpdated,
    required this.appConfig,
    required this.rootDescriptor,
    required super.child,
  });

  static String nameOf(BuildContext context) =>
      WerkbankAppInfo._of(context).name;

  static Widget? logoOf(BuildContext context) =>
      WerkbankAppInfo._of(context).logo;

  static DateTime? lastUpdatedOf(BuildContext context) =>
      WerkbankAppInfo._of(context).lastUpdated;

  static AppConfig appConfigOf(BuildContext context) =>
      WerkbankAppInfo._of(context).appConfig;

  static RootDescriptor rootDescriptorOf(BuildContext context) =>
      WerkbankAppInfo._of(context).rootDescriptor;

  static WerkbankAppInfo _of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No WerkbankApp found in context');
    return result!;
  }

  static WerkbankAppInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WerkbankAppInfo>();
  }

  final String name;
  final Widget? logo;
  final DateTime? lastUpdated;
  final AppConfig appConfig;
  final RootDescriptor rootDescriptor;

  @override
  bool updateShouldNotify(WerkbankAppInfo oldWidget) {
    return name != oldWidget.name ||
        logo != oldWidget.logo ||
        lastUpdated != oldWidget.lastUpdated ||
        appConfig != oldWidget.appConfig ||
        rootDescriptor != oldWidget.rootDescriptor;
  }
}
