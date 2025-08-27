import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/knob_preset_selector.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/knobs_state_entry.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// {@category Configuring Addons}
/// {@category Knobs}
class KnobsAddon extends Addon {
  const KnobsAddon() : super(id: addonId);

  static const addonId = 'knobs';

  @override
  List<AnyTransientUseCaseStateEntry> createTransientUseCaseStateEntries() => [
    KnobsStateEntry(),
  ];

  @override
  AddonLayerEntries get layers => AddonLayerEntries(
    management: [
      ManagementLayerEntry(
        id: 'ticker_provider_provider',
        builder: (context, child) => TickerProviderProvider(child: child),
      ),
    ],
  );

  @override
  List<ConfigureControlSection> buildConfigureTabControlSections(
    BuildContext context,
  ) {
    final useCasePath = ConfigureControlSection.access.useCaseOf(context).path;
    final knobsComposition = ConfigureControlSection.access
        .compositionOf(context)
        .knobs;
    return [
      ConfigureControlSection(
        id: 'knobs',
        title: Text(context.sL10n.addons.knobs.name),
        children: [
          const KnobPresetSelector(),
          /* TODO(lzuttermeister): Should this be allowed?
               In the design, the divider goes up to the edges.
               But that is reserved for the control sections. */
          const WDivider.horizontal(),
          for (final knob in knobsComposition.knobs)
            KeyedSubtree(
              key: ValueKey('${useCasePath}_${knob.id}'),
              child: Builder(builder: knob.build),
            ),
        ],
      ),
    ];
  }
}
