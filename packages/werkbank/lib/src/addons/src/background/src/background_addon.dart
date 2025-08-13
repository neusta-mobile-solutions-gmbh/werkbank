import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/background/background.dart';
import 'package:werkbank/src/addons/src/background/src/_internal/background_applier.dart';
import 'package:werkbank/src/addons/src/background/src/_internal/background_dropdown.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
class BackgroundAddon extends Addon {
  /// Creates a [BackgroundAddon] that allows you to select
  /// the background of the use case.
  ///
  /// Unless [includeDefaultBackgrounds] is set to `false`,
  /// some default backgrounds are included:
  /// - White
  /// - Black
  /// - None (transparent)
  /// - Checkerboard
  ///
  /// Additionally, you can provide your own [backgroundOptions].
  ///
  /// The [initialBackgroundOptionName] can be used to set the
  /// [BackgroundOption] that is initially selected for all use cases.
  /// When this is `null`, the default background option of the use case
  /// is used, which can be controlled by calls of methods on the
  /// [BackgroundComposer] while composing the use case.
  /// Consider keeping this `null` and setting the default background
  /// using one of the methods on the [BackgroundComposer] inside of the
  /// [WerkbankRoot.builder]. This way, nested use cases can still override
  /// this with a different default background.
  BackgroundAddon({
    bool includeDefaultBackgrounds = true,
    this.initialBackgroundOptionName,
    List<BackgroundOption> backgroundOptions = const [],
  }) : backgroundOptions = [
         if (includeDefaultBackgrounds) ..._defaultBackgroundOptions,
         ...backgroundOptions,
       ],
       super(id: addonId);

  static const addonId = 'background';

  static final _defaultBackgroundOptions = [
    BackgroundOption.color(
      name: 'White',
      color: Colors.white,
    ),
    BackgroundOption.color(
      name: 'Black',
      color: Colors.black,
    ),
    const BackgroundOption.widget(
      name: 'None',
      widget: SizedBox.expand(),
    ),
    const BackgroundOption.widget(
      name: 'Checkerboard',
      widget: WCheckerboardBackground(),
    ),
  ];

  /// A list of background options which can be selected.
  ///
  /// The [BackgroundOption.backgroundWidget] can assume that theming,
  /// localization etc. is already applied within their [BuildContext].
  final List<BackgroundOption> backgroundOptions;

  /// The name of the initially used background option.
  /// This may be a background option introduced by this addon or by another
  /// addon.
  /// If this is `null`, the default background option of the use case is used.
  final String? initialBackgroundOptionName;

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'background_state',
          after: const [
            FullLayerEntryId(
              addonId: 'device_frame',
              entryId: 'device_frame_state',
            ),
          ],
          builder: (context, child) => BackgroundManager(
            backgroundOptions: backgroundOptions,
            initialBackgroundOptionName: initialBackgroundOptionName,
            child: child,
          ),
        ),
      ],
      useCase: [
        UseCaseLayerEntry(
          id: 'background_applier',
          sortHint: SortHint.beforeMost,
          builder: (context, child) => BackgroundApplier(
            child: child,
          ),
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
        id: 'background',
        title: Text(context.sL10n.addons.background.name),
        sortHint: SortHint.beforeMost,
        children: [
          const BackgroundDropdown(),
        ],
      ),
    ];
  }
}
