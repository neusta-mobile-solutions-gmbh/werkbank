import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/ruler_overlay.dart';

class ConstraintsShortcuts extends StatefulWidget {
  const ConstraintsShortcuts({
    super.key,
    required this.child,
    required this.onModeChange,
  });

  final ValueChanged<ConstraintsMode> onModeChange;

  final Widget child;

  @override
  State<ConstraintsShortcuts> createState() => _ConstraintsShortcutsState();
}

class _ConstraintsShortcutsState extends State<ConstraintsShortcuts> {
  bool _isShiftPressed = false;
  bool _isAltPressed = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    // ctrl + mouse is occupied by the browser.
    // meta is not available on windows and linux.

    // Therefore we use alt and shift as modifiers.
    final isShiftEvent = {
      LogicalKeyboardKey.shiftLeft,
      LogicalKeyboardKey.shiftRight,
    }.contains(event.logicalKey);

    final isAltEvent = {
      LogicalKeyboardKey.altLeft,
      LogicalKeyboardKey.altRight,
    }.contains(event.logicalKey);
    if (event is KeyDownEvent) {
      if (isShiftEvent) {
        _isShiftPressed = true;
      }
      if (isAltEvent) {
        _isAltPressed = true;
      }
    } else if (event is KeyUpEvent) {
      if (isShiftEvent) {
        _isShiftPressed = false;
      }
      if (isAltEvent) {
        _isAltPressed = false;
      }
    }

    if (_isShiftPressed && _isAltPressed) {
      widget.onModeChange.call(ConstraintsMode.bothTight);
    } else if (_isShiftPressed) {
      widget.onModeChange.call(ConstraintsMode.min);
    } else if (_isAltPressed) {
      widget.onModeChange.call(ConstraintsMode.max);
    } else {
      widget.onModeChange.call(ConstraintsMode.tightOneAxis);
    }
    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
