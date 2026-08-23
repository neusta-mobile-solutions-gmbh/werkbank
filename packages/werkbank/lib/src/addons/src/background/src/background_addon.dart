import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/background/background.dart';
import 'package:werkbank/src/addons/src/background/src/_internal/background_applier.dart';
import 'package:werkbank/src/addons/src/background/src/_internal/background_dropdown.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
/// {@category Backgrounds}
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
  BackgroundAddon({
    bool includeDefaultBackgrounds = true,
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

  @override
  void registerGlobalStateControllers(GlobalStateControllerRegistry registry) {
    registry.register(
      BackgroundController.new,
      onUpdate: (controller) =>
          controller.updateBackgroundOptions(backgroundOptions),
    );
  }

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
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
