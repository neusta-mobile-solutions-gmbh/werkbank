import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';

class AccessorScope<T extends AddonAccessor> extends StatelessWidget {
  const AccessorScope.start({
    super.key,
    required this.child,
  }) : isStart = true;

  const AccessorScope.end({
    super.key,
    required this.child,
  }) : isStart = false;

  static bool isActive<T extends AddonAccessor>(BuildContext context) {
    final activeAccessorTypes = _AccessorScopeProvider.of(context);
    return activeAccessorTypes.contains(T);
  }

  final bool isStart;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeAccessorTypes = _AccessorScopeProvider.of(context).toSet();
    if (isStart) {
      activeAccessorTypes.add(T);
    } else {
      final wasRemoved = activeAccessorTypes.remove(T);
      assert(
        wasRemoved,
        'AccessorScope.end called without a matching '
        'AccessorScope.start for $T',
      );
    }
    return _AccessorScopeProvider(
      activeAccessorTypes: activeAccessorTypes,
      child: child,
    );
  }
}

class _AccessorScopeProvider extends InheritedWidget {
  const _AccessorScopeProvider({
    required this.activeAccessorTypes,
    required super.child,
  });

  final Set<Type> activeAccessorTypes;

  static Set<Type> of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_AccessorScopeProvider>();
    return result?.activeAccessorTypes ?? const {};
  }

  @override
  bool updateShouldNotify(_AccessorScopeProvider old) {
    return activeAccessorTypes != old.activeAccessorTypes;
  }
}
