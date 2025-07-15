import 'package:flutter/material.dart';

class MutableStateTickerProviderProvider extends StatefulWidget {
  const MutableStateTickerProviderProvider({
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
  State<MutableStateTickerProviderProvider> createState() =>
      _MutableStateTickerProviderProviderState();
}

class _MutableStateTickerProviderProviderState
    extends State<MutableStateTickerProviderProvider>
    with TickerProviderStateMixin<MutableStateTickerProviderProvider> {
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
