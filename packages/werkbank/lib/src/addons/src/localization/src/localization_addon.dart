import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/localization/src/_internal/locale_selector.dart';
import 'package:werkbank/src/addons/src/localization/src/_internal/localizations_applier.dart';
import 'package:werkbank/werkbank_old.dart';

/// {@category Configuring Addons}
class LocalizationAddon extends Addon {
  LocalizationAddon({
    required this.locales,
    this.localizationsDelegates = const [],
  }) : assert(
         locales.isNotEmpty,
         'locales must not be empty',
       ),
       super(id: addonId);

  static const addonId = 'localization';

  /// The [Locale]s which can be selected.
  final List<Locale> locales;

  /// The [LocalizationsDelegate]s added to the context of the use case
  /// using the [Localizations] widget.
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'localization_manager',
          builder: (context, child) => LocalizationManager(
            locales: locales,
            child: child,
          ),
        ),
      ],
      affiliationTransition: [
        AffiliationTransitionLayerEntry(
          id: 'localizations_applier',
          builder: (context, child) => LocalizationsApplier(
            localizationsDelegates: localizationsDelegates,
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
        id: 'localization',
        title: Text(context.sL10n.addons.localization.name),
        children: [
          LocaleSelector(
            locales: locales,
          ),
        ],
      ),
    ];
  }
}
