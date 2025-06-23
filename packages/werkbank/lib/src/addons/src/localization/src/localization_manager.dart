import 'package:flutter/material.dart';

class LocalizationManager extends StatefulWidget {
  const LocalizationManager({
    super.key,
    required this.locales,
    required this.child,
  });

  static Locale selectedLocaleOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LocalizationState>()!
        .locale;
  }

  final List<Locale> locales;
  final Widget child;

  static void setSelectedLocale(
    BuildContext context, {
    required Locale locale,
  }) {
    context
        .findAncestorStateOfType<_LocalizationManagerState>()!
        .setSelectedLocale(locale: locale);
  }

  @override
  State<LocalizationManager> createState() => _LocalizationManagerState();
}

class _LocalizationManagerState extends State<LocalizationManager> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedLocale = widget.locales.firstOrNull ?? const Locale('en');
  }

  @override
  void didUpdateWidget(covariant LocalizationManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locales != oldWidget.locales) {
      if (!widget.locales.contains(selectedLocale)) {
        selectedLocale = widget.locales.firstOrNull ?? const Locale('en');
      }
    }
  }

  void setSelectedLocale({required Locale locale}) {
    setState(() => selectedLocale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return _LocalizationState(
      locale: selectedLocale,
      child: widget.child,
    );
  }
}

class _LocalizationState extends InheritedWidget {
  const _LocalizationState({
    required this.locale,
    required super.child,
  });

  final Locale locale;

  @override
  bool updateShouldNotify(_LocalizationState oldWidget) {
    return locale != oldWidget.locale;
  }
}
