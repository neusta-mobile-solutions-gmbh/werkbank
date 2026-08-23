import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/global_state/global_state.dart';

// TODO: document
abstract class ValueNotifierGlobalStateController<T> extends ValueNotifier<T>
    implements GlobalStateController {
  ValueNotifierGlobalStateController(super._value);

  T watch(BuildContext context) =>
      _InheritedValueMap.of(context, aspect: this)[this] as T;

  @override
  Widget build(
    BuildContext context,
    GlobalStateControllerBuildData data,
    Widget child,
  ) {
    return ValueListenableBuilder(
      valueListenable: this,
      builder: (context, value, _) {
        /* TODO: Can we avoid rebuilding all controllers when
            one of them changes? Options:
            - Make give this a self-generic type and add an inherited widget
              with this type.
            - Add a single inherited model with a map to the manager.
              This would mean that this subclass could not have ben added by
              third parties.
              Maybe that's fine if we test for the ValueNotifier interface,
              but that still leaves the problem of where to put the .of method.
            - Add a way that a controller can register itself for having its
              value put inside an inherited widget. */
        return _InheritedValueMap(
          map: _InheritedValueMap.of(context).put(this, value),
          child: child,
        );
      },
    );
  }
}

typedef _MapType =
    PersistentHashMap<ValueNotifierGlobalStateController<Object?>, Object?>;

class _InheritedValueMap
    extends InheritedModel<ValueNotifierGlobalStateController<Object?>> {
  const _InheritedValueMap({
    required this.map,
    required super.child,
  });

  static _MapType of(
    BuildContext context, {
    ValueNotifierGlobalStateController<Object?>? aspect,
  }) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_InheritedValueMap>(aspect: aspect);
    return widget?.map ?? const PersistentHashMap.empty();
  }

  final _MapType map;

  @override
  bool updateShouldNotify(_InheritedValueMap old) {
    return map != old.map;
  }

  @override
  bool updateShouldNotifyDependent(
    _InheritedValueMap oldWidget,
    Set<ValueNotifierGlobalStateController<Object?>> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (map[dependency] != oldWidget.map[dependency]) {
        return true;
      }
    }
    return false;
  }
}
