import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/debugging/src/_internal/debugging_performance_overlay.dart';
import 'package:werkbank/src/addons/src/debugging/src/_internal/debugging_repaint_children.dart';
import 'package:werkbank/src/components/components.dart';

class PerformanceOverlaySwitch extends StatefulWidget {
  const PerformanceOverlaySwitch({super.key});

  @override
  State<PerformanceOverlaySwitch> createState() =>
      _PerformanceOverlaySwitchState();
}

class _PerformanceOverlaySwitchState extends State<PerformanceOverlaySwitch> {
  @override
  Widget build(BuildContext context) {
    return _DebugSwitch(
      title: Text(context.sL10n.addons.debugging.controls.performanceOverlay),
      value: DebuggingPerformanceOverlay.enabledOf(context),
      onChanged: (value) {
        DebuggingPerformanceOverlay.setEnabled(context, enabled: value);
      },
    );
  }
}

class PaintBaselinesSwitch extends StatefulWidget {
  const PaintBaselinesSwitch({super.key});

  @override
  State<PaintBaselinesSwitch> createState() => _PaintBaselinesSwitchState();
}

class _PaintBaselinesSwitchState extends State<PaintBaselinesSwitch> {
  @override
  Widget build(BuildContext context) {
    return _DebugSwitch(
      title: Text(context.sL10n.addons.debugging.controls.paintBaselines),
      value: debugPaintBaselinesEnabled,
      onChanged: (value) {
        debugPaintBaselinesEnabled = value;
        setState(() {});
        DebuggingRepaintChildren.repaintAllChildren(context);
      },
    );
  }
}

class PaintSizeSwitch extends StatefulWidget {
  const PaintSizeSwitch({super.key});

  @override
  State<PaintSizeSwitch> createState() => _PaintSizeSwitchState();
}

class _PaintSizeSwitchState extends State<PaintSizeSwitch> {
  @override
  Widget build(BuildContext context) {
    return _DebugSwitch(
      title: Text(context.sL10n.addons.debugging.controls.paintSize),
      value: debugPaintSizeEnabled,
      onChanged: (value) {
        debugPaintSizeEnabled = value;
        setState(() {});
        DebuggingRepaintChildren.repaintAllChildren(context);
      },
    );
  }
}

class RepaintTextRainbowSwitch extends StatefulWidget {
  const RepaintTextRainbowSwitch({super.key});

  @override
  State<RepaintTextRainbowSwitch> createState() =>
      _RepaintTextRainbowSwitchState();
}

class _RepaintTextRainbowSwitchState extends State<RepaintTextRainbowSwitch> {
  @override
  Widget build(BuildContext context) {
    return _DebugSwitch(
      title: Text(context.sL10n.addons.debugging.controls.repaintTextRainbow),
      value: debugRepaintTextRainbowEnabled,
      onChanged: (value) {
        debugRepaintTextRainbowEnabled = value;
        setState(() {});
        DebuggingRepaintChildren.repaintAllChildren(context);
      },
    );
  }
}

class RepaintRainbowSwitch extends StatefulWidget {
  const RepaintRainbowSwitch({super.key});

  @override
  State<RepaintRainbowSwitch> createState() => _RepaintRainbowSwitchState();
}

class _RepaintRainbowSwitchState extends State<RepaintRainbowSwitch> {
  @override
  Widget build(BuildContext context) {
    return _DebugSwitch(
      title: Text(context.sL10n.addons.debugging.controls.repaintRainbow),
      value: debugRepaintRainbowEnabled,
      onChanged: (value) {
        debugRepaintRainbowEnabled = value;
        setState(() {});
        DebuggingRepaintChildren.repaintAllChildren(context);
      },
    );
  }
}

class _DebugSwitch extends StatefulWidget {
  const _DebugSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final Widget title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<_DebugSwitch> createState() => _DebugSwitchState();
}

class _DebugSwitchState extends State<_DebugSwitch> {
  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: widget.title,
      control: WSwitch(
        value: widget.value,
        onChanged: widget.onChanged,
        falseLabel: Text(context.sL10n.generic.yesNoSwitch.no),
        trueLabel: Text(context.sL10n.generic.yesNoSwitch.yes),
      ),
    );
  }
}
