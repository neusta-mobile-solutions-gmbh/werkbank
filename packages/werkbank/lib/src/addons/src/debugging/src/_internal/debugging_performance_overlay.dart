import 'package:flutter/material.dart';

class DebuggingPerformanceOverlay extends StatefulWidget {
  const DebuggingPerformanceOverlay({
    super.key,
    required this.child,
  });

  static bool enabledOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PerformanceOverlayState>()!
        .enabled;
  }

  static void setEnabled(BuildContext context, {required bool enabled}) {
    context
        .findAncestorStateOfType<_DebuggingPerformanceOverlayState>()!
        .setEnabled(enabled: enabled);
  }

  final Widget child;

  @override
  State<DebuggingPerformanceOverlay> createState() =>
      _DebuggingPerformanceOverlayState();
}

class _DebuggingPerformanceOverlayState
    extends State<DebuggingPerformanceOverlay> {
  bool enabled = false;

  void setEnabled({required bool enabled}) {
    setState(() {
      this.enabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PerformanceOverlayState(
      enabled: enabled,
      child: Stack(
        children: [
          widget.child,
          if (enabled)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: PerformanceOverlay.allEnabled(),
            ),
        ],
      ),
    );
  }
}

class _PerformanceOverlayState extends InheritedWidget {
  const _PerformanceOverlayState({
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  @override
  bool updateShouldNotify(_PerformanceOverlayState oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
