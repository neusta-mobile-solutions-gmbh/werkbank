import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/accessibility_state_entry.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/bold_text_control.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/colorblindness_overlay/colorblindness_simulation_overlay.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector_overlay.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/simulated_color_blindness_type_control.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/text_scale_factor_control.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
class AccessibilityAddon extends Addon {
  const AccessibilityAddon() : super(id: addonId);

  static const addonId = 'accessibility';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'accessibility_manager',
          sortHint: SortHint.beforeMost,
          builder: (context, child) => AccessibilityManager(child: child),
        ),
      ],
      useCaseOverlay: [
        UseCaseOverlayLayerEntry(
          id: 'semantics_overlay',
          includeInOverlay: false,
          builder: (context, child) => SemanticsInspectorOverlay(child: child),
        ),
      ],
      affiliationTransition: [
        AffiliationTransitionLayerEntry(
          id: 'accessibility_affiliation_transition',
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                AccessibilityManager.textScaleFactorOf(context),
              ),
              boldText: AccessibilityManager.boldTextOf(context),
            ),
            child: child,
          ),
        ),
        AffiliationTransitionLayerEntry(
          id: 'colorblindness_overlay',
          builder: (context, child) => ColorBlindnessSimulationOverlay(
            child: child,
          ),
        ),
        AffiliationTransitionLayerEntry(
          id: 'include_in_semantics_inspector',
          includeInOverlay: false,
          appOnly: true,
          sortHint: const SortHint(1000000000000),
          builder: (context, child) {
            return IncludeInSemanticsMonitor(
              include:
                  AccessibilityManager.semanticsScopeOf(context) ==
                  SemanticsScope.app,
              child: child,
            );
          },
        ),
      ],
      useCase: [
        UseCaseLayerEntry(
          id: 'include_in_semantics_inspector',
          includeInOverlay: false,
          appOnly: true,
          sortHint: const SortHint(-1000000000000),
          builder: (context, child) {
            return IncludeInSemanticsMonitor(
              include:
                  AccessibilityManager.semanticsScopeOf(context) ==
                  SemanticsScope.useCase,
              child: child,
            );
          },
        ),
      ],
    );
  }

  @override
  List<AnyRetainedUseCaseStateEntry> createRetainedUseCaseStateEntries() => [
    AccessibilityStateEntry(),
  ];

  @override
  List<InspectControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) {
    return [
      InspectControlSection(
        id: 'semantics_inspector',
        title: Text(context.sL10n.addons.accessibility.inspector.name),
        sortHint: SortHint.beforeMost,
        children: [
          const SemanticsInspector(),
        ],
      ),
    ];
  }

  @override
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) {
    return [
      SettingsControlSection(
        id: 'accessibility',
        title: Text(context.sL10n.addons.accessibility.name),
        children: [
          const TextScaleFactorControl(),
          const BoldTextControl(),
          const SimulatedColorBlindnessTypeControl(),
        ],
      ),
    ];
  }
}
