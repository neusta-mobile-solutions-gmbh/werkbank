import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/theming/src/_internal/theme_option_applier.dart';
import 'package:werkbank/src/addons/src/theming/src/_internal/theme_selector.dart';
import 'package:werkbank/src/addons/src/theming/theming.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
class ThemingAddon extends Addon {
  const ThemingAddon({
    required this.themeOptions,
  }) : super(id: addonId);

  static const addonId = 'theming';

  final List<ThemeOption> themeOptions;

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'theming_manager',
          builder: (context, child) => ThemingManager(
            themeOptions: themeOptions,
            child: child,
          ),
        ),
      ],
      affiliationTransition: [
        AffiliationTransitionLayerEntry(
          id: 'theme_option_applier',
          builder: (context, child) => ThemeOptionApplier(
            themeOptions: themeOptions,
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
        id: 'theming',
        title: Text(context.sL10n.addons.theming.name),
        sortHint: SortHint.beforeMost,
        children: [
          ThemeSelector(
            themeOptions: themeOptions,
          ),
        ],
      ),
    ];
  }
}

@immutable
class ThemeOption {
  const ThemeOption({
    required this.name,
    required this.wrapperBuilder,
  });

  factory ThemeOption.material({
    required String name,
    Widget Function(BuildContext context, Widget child)? wrapperBuilder,
    required ThemeData Function(BuildContext context) themeDataBuilder,
  }) => ThemeOption(
    name: name,
    wrapperBuilder: (context, child) {
      final themedChild = Builder(
        builder: (context) {
          return Theme(
            data: themeDataBuilder(context),
            child: child,
          );
        },
      );
      return wrapperBuilder != null
          ? wrapperBuilder(context, themedChild)
          : themedChild;
    },
  );

  factory ThemeOption.cupertino({
    required String name,
    Widget Function(BuildContext context, Widget child)? wrapperBuilder,
    required CupertinoThemeData Function(BuildContext context) themeDataBuilder,
  }) => ThemeOption(
    name: name,
    wrapperBuilder: (context, child) {
      final themedChild = Builder(
        builder: (context) {
          return CupertinoTheme(
            data: themeDataBuilder(context),
            child: child,
          );
        },
      );

      return wrapperBuilder != null
          ? wrapperBuilder(context, themedChild)
          : themedChild;
    },
  );

  final String name;
  final Widget Function(BuildContext context, Widget child)? wrapperBuilder;
}
