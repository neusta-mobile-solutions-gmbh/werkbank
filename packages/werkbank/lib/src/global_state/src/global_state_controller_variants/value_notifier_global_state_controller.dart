import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: Use wherever possible.
// TODO: document
abstract base class ValueNotifierGlobalStateController<T>
    extends ValueNotifier<T>
    implements GlobalStateController {
  ValueNotifierGlobalStateController(super._value);

  T watch(BuildContext context) => _watch(context);

  late final T Function(BuildContext context) _watch;
  late final Widget Function({required T value, required Widget child})
  _inherited;

  @override
  void init<C extends GlobalStateController>(GlobalStateControllerData data) {
    _watch = (context) => _InheritedValue.of<C>(context) as T;
    _inherited = ({required value, required child}) => _InheritedValue<C>(
      value: value,
      child: child,
    );
  }

  @override
  Widget build(
    BuildContext context,
    GlobalStateControllerData data,
    Widget child,
  ) {
    return ValueListenableBuilder(
      valueListenable: this,
      builder: (context, value, _) {
        return _inherited(
          value: value,
          child: child,
        );
      },
    );
  }
}

class _InheritedValue<C> extends InheritedWidget {
  const _InheritedValue({
    required this.value,
    required super.child,
  });

  static Object? of<C>(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_InheritedValue<C>>();
    return widget!.value;
  }

  final Object? value;

  @override
  bool updateShouldNotify(_InheritedValue<C> old) {
    return value != old.value;
  }
}
