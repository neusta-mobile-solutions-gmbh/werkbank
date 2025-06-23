import 'package:flutter/material.dart';

class TickerProviderProvider extends StatefulWidget {
  const TickerProviderProvider({
    super.key,
    required this.child,
  });

  static TickerProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_InheritedTickerProviderProvider>();
    return provider!.tickerProvider;
  }

  final Widget child;

  @override
  State<TickerProviderProvider> createState() => _TickerProviderProviderState();
}

class _TickerProviderProviderState extends State<TickerProviderProvider>
    with TickerProviderStateMixin<TickerProviderProvider> {
  @override
  Widget build(BuildContext context) {
    return _InheritedTickerProviderProvider(
      tickerProvider: this,
      child: widget.child,
    );
  }
}

class _InheritedTickerProviderProvider extends InheritedWidget {
  const _InheritedTickerProviderProvider({
    required this.tickerProvider,
    required super.child,
  });

  final TickerProvider tickerProvider;

  @override
  bool updateShouldNotify(_InheritedTickerProviderProvider oldWidget) {
    return oldWidget.tickerProvider != tickerProvider;
  }
}
