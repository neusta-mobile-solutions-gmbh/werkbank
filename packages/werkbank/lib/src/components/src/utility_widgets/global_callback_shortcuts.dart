import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@category Werkbank Components}
class GlobalCallbackShortcuts extends StatefulWidget {
  const GlobalCallbackShortcuts({
    super.key,
    required this.bindings,
    required this.child,
  });

  final Map<ShortcutActivator, VoidCallback> bindings;
  final Widget child;

  @override
  State<GlobalCallbackShortcuts> createState() =>
      _GlobalCallbackShortcutsState();
}

class _GlobalCallbackShortcutsState extends State<GlobalCallbackShortcuts> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  /// Implementation copied and modified from [CallbackShortcuts]
  /// to use the HardwareKeyboard instance, and not rely on the Focus widget
  bool _handleKeyEvent(KeyEvent event) {
    var result = KeyEventResult.ignored;
    for (final activator in widget.bindings.keys) {
      result = _applyKeyEventBinding(activator, event)
          ? KeyEventResult.handled
          : result;
    }

    return result == KeyEventResult.handled;
  }

  bool _applyKeyEventBinding(ShortcutActivator activator, KeyEvent event) {
    if (activator.accepts(event, HardwareKeyboard.instance)) {
      widget.bindings[activator]!.call();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
