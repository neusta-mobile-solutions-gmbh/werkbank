import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_state_entry.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/ruler_overlay.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/size_selector.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/view_constraints_enforcer.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/view_constraints_preset_selector.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/view_constraints_selector.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
/// {@category Constraints & Sizing}
/// {@category Overview}
class ConstraintsAddon extends Addon {
  const ConstraintsAddon() : super(id: addonId);

  static const addonId = 'constraints';

  @override
  List<AnyTransientUseCaseStateEntry> createTransientUseCaseStateEntries() => [
    ConstraintsStateEntry(),
  ];

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      useCaseOverlay: [
        UseCaseOverlayLayerEntry(
          id: 'ruler_overlay',
          includeInOverlay: false,
          sortHint: const SortHint(-1000000),
          before: const [
            FullLayerEntryId(addonId: 'zoom', entryId: 'zoom_overlay'),
          ],
          builder: (context, child) => RulerOverlay(child: child),
        ),
      ],
      useCaseLayout: [
        UseCaseLayoutLayerEntry(
          id: 'constraints_enforcer',
          builder: (context, child) => ViewConstraintsEnforcer(
            child: child,
          ),
        ),
      ],
      useCaseFitted: [
        UseCaseFittedLayerEntry(
          id: 'layout_notifier',
          appOnly: true,
          includeInOverlay: false,
          sortHint: const SortHint(1000000),
          builder: (context, child) => WLayoutChangedNotifier(
            link: RulerLayoutReferenceLinkProvider.of(context),
            onLayoutChanged: (layoutInfo) {
              context.dispatchNotification(
                RelativeLayoutChangedNotification(layoutInfo: layoutInfo),
              );
            },
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<UseCaseControlSection> buildConfigureTabControlSections(
    BuildContext context,
  ) {
    final constraintsComposition = UseCaseControlSection.access
        .compositionOf(context)
        .constraints;
    return [
      UseCaseControlSection(
        id: 'constraints',
        title: Text(context.sL10n.addons.constraints.name),
        sortHint: SortHint.beforeMost,
        children: [
          const ViewConstraintsPresetSelector(),
          /* TODO(lzuttermeister): Should this be allowed?
               In the design, the divider goes up to the edges.
               But that is reserved for the control sections. */
          const WDivider.horizontal(),
          ViewConstraintsSelector(
            constraintsComposition: constraintsComposition,
          ),
          SizeSelector(constraintsComposition: constraintsComposition),
        ],
      ),
    ];
  }

  @override
  AddonDescription? buildDescription(BuildContext context) {
    final sL10n = context.sL10n;
    return AddonDescription(
      priority: DescriptionPriority.high,
      markdownDescription: '''
  # Constraints

  An addon for the werkbank.
  ''',
      shortcuts: [
        ShortcutsSection(
          title: sL10n.addons.constraints.shortcuts.title,
          subTitle: sL10n.addons.constraints.shortcuts.subTitle,
          shortcuts: {
            {
              KeyOrText.key(LogicalKeyboardKey.shift),
              KeyOrText.key(LogicalKeyboardKey.alt),
            }: sL10n.addons.constraints.shortcuts.descriptionResize,
            {KeyOrText.key(LogicalKeyboardKey.shift)}:
                sL10n.addons.constraints.shortcuts.descriptionMinSize,
            {KeyOrText.key(LogicalKeyboardKey.alt)}:
                sL10n.addons.constraints.shortcuts.descriptionMaxSize,
          },
        ),
      ],
    );
  }
}
