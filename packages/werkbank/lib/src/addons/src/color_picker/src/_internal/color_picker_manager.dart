import 'package:flutter/material.dart';

class ColorPickerManager extends StatefulWidget {
  const ColorPickerManager({super.key, required this.child});

  static bool enabledOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ColorPickerState>()!
        .enabled;
  }

  static void setEnabled(BuildContext context, {required bool enabled}) {
    context.findAncestorStateOfType<_ColorPickerManagerState>()!.setEnabled(
      enabled: enabled,
    );
  }

  static Color? colorOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ColorPickerState>()
        ?.selectedColor;
  }

  static void setColor(
    BuildContext context, {
    required Color? color,
  }) {
    context.findAncestorStateOfType<_ColorPickerManagerState>()!.setColor(
      selectedColor: color,
    );
  }

  final Widget child;

  @override
  State<ColorPickerManager> createState() => _ColorPickerManagerState();
}

class _ColorPickerManagerState extends State<ColorPickerManager> {
  bool enabled = false;
  Color? selectedColor;

  void setEnabled({required bool enabled}) {
    setState(() {
      this.enabled = enabled;
    });
  }

  void setColor({required Color? selectedColor}) {
    setState(() {
      this.selectedColor = selectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ColorPickerState(
      enabled: enabled,
      selectedColor: selectedColor,
      child: widget.child,
    );
  }
}

class _ColorPickerState extends InheritedWidget {
  const _ColorPickerState({
    required this.enabled,
    required this.selectedColor,
    required super.child,
  });

  final bool enabled;
  final Color? selectedColor;

  @override
  bool updateShouldNotify(_ColorPickerState oldWidget) {
    return enabled != oldWidget.enabled ||
        selectedColor != oldWidget.selectedColor;
  }
}
