import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addon_config/addon_config.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/utils/utils.dart';

/// An [Addon] that enables control over page transitions
///
/// Minimal example to show that the PageTransitionOptions of Werkbank
/// can be controlled via Addon.
///
/// It only provides a switch to enable or disable the page transition.
///
/// {@category Configuring Addons}
///
/// Note: This addon is not included by default in [AddonConfig],
/// as most apps do not need to customize page transitions.
/// You can add it manually to your addon list if needed.
/// It is mainly provided as an example of how to control
/// page transitions via an Addon.
class PageTransitionAddon extends Addon {
  const PageTransitionAddon() : super(id: addonId);

  static const addonId = 'page_transition';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'page_transition_options',
          appOnly: true,
          sortHint: SortHint.beforeMost,
          builder: (context, child) =>
              PageTransitionEnablerManager(child: child),
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
        id: 'page_transition',
        title: Text(context.sL10n.addons.pageTransition.name),
        sortHint: const SortHint(10000),
        children: [
          WSwitch(
            value: PageTransitionEnablerManager.enabledOf(context),
            onChanged: (value) {
              PageTransitionEnablerManager.setEnabled(
                context,
                enabled: value,
              );
            },
            falseLabel: Text(context.sL10n.generic.onOffSwitch.off),
            trueLabel: Text(context.sL10n.generic.onOffSwitch.on),
          ),
        ],
      ),
    ];
  }
}

class PageTransitionEnablerManager extends StatefulWidget {
  const PageTransitionEnablerManager({
    required this.child,
    super.key,
  });

  final Widget child;

  static bool enabledOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PageTransitionEnablerState>()!
        .enabled;
  }

  static void setEnabled(BuildContext context, {required bool enabled}) {
    context
        .findAncestorStateOfType<_PageTransitionEnablerManagerState>()!
        .setEnabled(enabled: enabled);
  }

  @override
  State<PageTransitionEnablerManager> createState() =>
      _PageTransitionEnablerManagerState();
}

class _PageTransitionEnablerManagerState
    extends State<PageTransitionEnablerManager> {
  bool enabled = true;

  void setEnabled({required bool enabled}) {
    setState(() {
      this.enabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PageTransitionEnablerState(
      enabled: enabled,
      child: PageTransitionOptions(
        pageTransitionDuration: enabled ? null : Duration.zero,
        child: widget.child,
      ),
    );
  }
}

class _PageTransitionEnablerState extends InheritedWidget {
  const _PageTransitionEnablerState({
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  @override
  bool updateShouldNotify(_PageTransitionEnablerState oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
