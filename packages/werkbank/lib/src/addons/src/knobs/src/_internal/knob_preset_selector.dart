import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

class KnobPresetSelector extends StatelessWidget {
  const KnobPresetSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final composition = ConfigureControlSection.access.compositionOf(context);
    final knobsComposition = composition.knobs;
    final metadata = ConfigureControlSection.access.metadataOf(context);

    final presetL10n = context.sL10n.addons.knobs.controls.preset;
    void goToPresetOverview() {
      final snapshot = composition.saveSnapshot();
      ConfigureControlSection.access
          .routerOf(context)
          .goTo(
            UseCaseOverviewNavState(
              descriptor: ConfigureControlSection.access.useCaseOf(context),
              config: UseCaseOverviewConfig(
                entryBuilder: (metadata) {
                  return [
                    for (final preset in metadata.knobPresets)
                      UseCaseOverviewEntry(
                        name: switch (preset) {
                          InitialKnobPreset() => presetL10n.values.initial,
                          DefinedKnobPreset() => preset.name,
                        },
                        initialMutation: (controller) {
                          controller.loadSnapshot(snapshot);
                          controller.knobs.loadPreset(preset);
                        },
                      ),
                  ];
                },
              ),
            ),
          );
    }

    return ValueListenableBuilder(
      valueListenable: knobsComposition.activeKnobPresetListenable,
      builder: (context, value, child) {
        return WControlItem(
          title: Text(presetL10n.name),
          control: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: WIconButton(
                  onPressed: goToPresetOverview,
                  icon: const Icon(WerkbankIcons.squaresFour),
                ),
              ),
              Expanded(
                child: WDropdown<KnobPreset?>(
                  onChanged: (preset) {
                    if (preset != null) {
                      knobsComposition.loadPreset(preset);
                    }
                  },
                  value: value,
                  items: [
                    /* TODO(lzuttermeister): This option should not
                         be selectable. */
                    WDropdownMenuItem(
                      value: null,
                      child: Text(
                        presetL10n.values.unknown,
                      ),
                    ),
                    for (final preset in metadata.knobPresets)
                      WDropdownMenuItem(
                        value: preset,
                        child: Text(
                          switch (preset) {
                            InitialKnobPreset() => presetL10n.values.initial,
                            DefinedKnobPreset() => preset.name,
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
