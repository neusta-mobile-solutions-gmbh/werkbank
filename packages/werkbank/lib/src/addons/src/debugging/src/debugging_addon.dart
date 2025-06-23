import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/debugging/src/_internal/debugging_performance_overlay.dart';
import 'package:werkbank/src/addons/src/debugging/src/_internal/debugging_repaint_children.dart';
import 'package:werkbank/src/addons/src/debugging/src/_internal/switches.dart';
import 'package:werkbank/src/addons/src/debugging/src/_internal/time_dialation_slider.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
class DebuggingAddon extends Addon {
  const DebuggingAddon() : super(id: addonId);

  static const addonId = 'debugging';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      applicationOverlay: [
        if (kDebugMode)
          ApplicationOverlayLayerEntry(
            id: 'debugging_performance_overlay',
            sortHint: SortHint.beforeMost,
            builder: (context, child) =>
                DebuggingPerformanceOverlay(child: child),
          ),
        if (kDebugMode)
          ApplicationOverlayLayerEntry(
            id: 'shady_debugging_helper',
            sortHint: SortHint.beforeMost,
            builder: (context, child) => DebuggingRepaintChildren(child: child),
          ),
      ],
    );
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    return [
      SettingsControlSection(
        id: 'debugging',
        title: Text(context.sL10n.addons.debugging.name),
        children: const [
          if (kDebugMode && !kIsWeb) PerformanceOverlaySwitch(),

          /// All these controls have the same problem in common.
          /// They are setting a global state of flutter
          /// but are not able to listen to changes.
          /// If some other party is changing them too,
          /// we will not be able to reflect that change.
          if (kDebugMode) PaintBaselinesSwitch(),
          if (kDebugMode) PaintSizeSwitch(),
          if (kDebugMode) RepaintTextRainbowSwitch(),
          if (kDebugMode) RepaintRainbowSwitch(),
          TimeDialationSlider(),
        ],
      ),
    ];
  }
}
