import 'package:flutter/material.dart';

class HotReloadEffectManager extends StatefulWidget {
  const HotReloadEffectManager({
    super.key,
    required this.child,
  });

  static bool enabledOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_HotReloadEffectState>()!
        .enabled;
  }

  static void setEnabled(BuildContext context, {required bool enabled}) {
    context.findAncestorStateOfType<_HotReloadEffectManagerState>()!.setEnabled(
      enabled: enabled,
    );
  }

  static const Curve curve = Curves.easeOutQuad;

  final Widget child;

  @override
  State<HotReloadEffectManager> createState() => _HotReloadEffectManagerState();
}

class _HotReloadEffectManagerState extends State<HotReloadEffectManager> {
  bool enabled = true;

  void setEnabled({required bool enabled}) {
    setState(() {
      this.enabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _HotReloadEffectState(
      enabled: enabled,
      child: widget.child,
    );
  }
}

class _HotReloadEffectState extends InheritedWidget {
  const _HotReloadEffectState({
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  @override
  bool updateShouldNotify(_HotReloadEffectState oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
