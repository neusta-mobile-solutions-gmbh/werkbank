import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/hot_reload_effect/src/_internal/hot_reload_effect_handler.dart';
import 'package:werkbank/src/addons/src/hot_reload_effect/src/_internal/restart_effect_handler.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
class HotReloadEffectAddon extends Addon {
  const HotReloadEffectAddon({
    this.showControl = false,
  }) : super(id: addonId);

  static const addonId = 'hot_reload_effect';
  final bool showControl;

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        if (kDebugMode)
          ManagementLayerEntry(
            id: 'hot_reload_effect_state',
            sortHint: SortHint.beforeMost,
            builder: (context, child) => HotReloadEffectManager(child: child),
          ),
      ],
      applicationOverlay: [
        if (kDebugMode)
          ApplicationOverlayLayerEntry(
            id: 'hot_restart',
            sortHint: SortHint.beforeMost,
            builder: (context, child) => RestartEffectHandler(child: child),
          ),
      ],
      useCaseOverlay: [
        if (kDebugMode)
          UseCaseOverlayLayerEntry(
            id: 'hot_reload',
            sortHint: const SortHint(-10000),
            builder: (context, child) => HotReloadEffectHandler(child: child),
          ),
      ],
    );
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    if (!kDebugMode) {
      return [];
    }

    return [
      if (showControl)
        SettingsControlSection(
          id: 'hot_reload_effect',
          title: Text(context.sL10n.addons.hotReloadEffect.name),
          sortHint: const SortHint(10000),
          children: [
            WSwitch(
              value: HotReloadEffectManager.enabledOf(context),
              onChanged: (value) {
                HotReloadEffectManager.setEnabled(context, enabled: value);
              },
              falseLabel: Text(context.sL10n.generic.onOffSwitch.off),
              trueLabel: Text(context.sL10n.generic.onOffSwitch.on),
            ),
          ],
        ),
    ];
  }
}
