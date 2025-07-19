import 'package:werkbank/werkbank.dart';

/// {@category Get Started}
/// {@category File Structure}
/// {@category Configuring Addons}
/// A class that defines which addons are used.
/// This needs to be passed to a [WerkbankApp] or [DisplayApp].
/// If you are using both, make sure to pass the same [AddonConfig] in order to
/// ensure consistent behavior.
class AddonConfig {
  /// Constructs an [AddonConfig] using the provided [addons] and
  /// unless [includeDefaultAddons] is set to `false`, the default addons.
  ///
  /// The default addons are:
  /// - [KnobsAddon]
  /// - [ConstraintsAddon]
  /// - [ViewerAddon]
  /// - [AccessibilityAddon]
  /// - [BackgroundAddon]
  /// - [WrappingAddon]
  /// - [ColorPickerAddon]
  /// - [DescriptionAddon]
  /// - [DebuggingAddon]
  /// - [ReportAddon]
  /// - [RecentHistoryAddon]
  /// - [AcknowledgedAddon]
  /// - [WerkbankThemeAddon]
  /// - [HotReloadEffectAddon]
  /// - [OrderingAddon]
  /// - [PageTransitionAddon]
  ///
  /// These addons include some basic features, so it is recommended to
  /// include them.
  ///
  /// Default addons can be added to the [addons] list to overwrite the
  /// the included ones with a different configuration.
  ///
  /// If you only want to exclude some of the default addons, you will have to
  /// set [includeDefaultAddons] to `false` and add the default addons
  /// you want to include back to the [addons] list.
  ///
  /// Should you choose not to include some or all of the default addons,
  /// consider importing a custom index/barrel file in your use cases which
  /// exports the default werkbank import but hides features
  /// such as extension on the [UseCaseComposer] from the addons
  /// you are not using.
  ///
  /// The [addons] list must not contain the same [Addon]
  /// (as identified by its [Addon.id]) more than once.
  ///
  /// The [ThemingAddon] and the [LocalizationAddon] are not included in the
  /// default addons, because they require additional configuration.
  /// But since pretty much every app uses theming and
  /// localization (even if only with one locale),
  /// it is recommended to include them in [addons].
  factory AddonConfig({
    required List<Addon> addons,
    bool includeDefaultAddons = true,
  }) {
    final addonIds = <String>{};
    final duplicateIds = addons
        .map((a) => a.id)
        .where((id) => !addonIds.add(id))
        .toList(growable: false);
    if (duplicateIds.isNotEmpty) {
      throw ArgumentError(
        'Cannot add the same addon multiple times. '
        'Duplicates: ${duplicateIds.join(', ')}',
      );
    }

    late final defaultAddons = [
      const KnobsAddon(),
      const ConstraintsAddon(),
      const ViewerAddon(),
      const AccessibilityAddon(),
      const StateAddon(),
      BackgroundAddon(),
      const WrappingAddon(),
      const ColorPickerAddon(),
      const DescriptionAddon(),
      const DebuggingAddon(),
      const ReportAddon(),
      const RecentHistoryAddon(),
      const AcknowledgedAddon(),
      const WerkbankThemeAddon(),
      const HotReloadEffectAddon(),
      // Both not included by default, as they are rarely needed.
      // You can add it manually to check it out.
      // Kept in the codebase as an example.
      // const OrderingAddon(),
      // const PageTransitionAddon(),
    ];

    final allAddons = [
      if (includeDefaultAddons) ...defaultAddons,
      ...addons,
    ];

    final deduplicatedAddons = {
      for (final addon in allAddons) addon.id: addon,
    }.values.toList(growable: false)..sort((a, b) => a.id.compareTo(b.id));
    return AddonConfig._(deduplicatedAddons);
  }

  AddonConfig._(this.addons);

  /// The list of addons that are used.
  final List<Addon> addons;
}
