///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsGenericEn generic = TranslationsGenericEn._(_root);
  late final TranslationsAddonsEn addons = TranslationsAddonsEn._(_root);
  late final TranslationsAppEn app = TranslationsAppEn._(_root);
  late final TranslationsNavigationPanelEn navigationPanel =
      TranslationsNavigationPanelEn._(_root);
  late final TranslationsConfigurationPanelEn configurationPanel =
      TranslationsConfigurationPanelEn._(_root);
  late final TranslationsShortcutsEn shortcuts = TranslationsShortcutsEn._(
    _root,
  );
  late final TranslationsOverviewEn overview = TranslationsOverviewEn._(_root);
}

// Path: generic
class TranslationsGenericEn {
  TranslationsGenericEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsGenericYesNoSwitchEn yesNoSwitch =
      TranslationsGenericYesNoSwitchEn._(_root);
  late final TranslationsGenericOnOffSwitchEn onOffSwitch =
      TranslationsGenericOnOffSwitchEn._(_root);
}

// Path: addons
class TranslationsAddonsEn {
  TranslationsAddonsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsAccessibilityEn accessibility =
      TranslationsAddonsAccessibilityEn._(_root);
  late final TranslationsAddonsBackgroundEn background =
      TranslationsAddonsBackgroundEn._(_root);
  late final TranslationsAddonsDebuggingEn debugging =
      TranslationsAddonsDebuggingEn._(_root);
  late final TranslationsAddonsHotReloadEffectEn hotReloadEffect =
      TranslationsAddonsHotReloadEffectEn._(_root);
  late final TranslationsAddonsKnobsEn knobs = TranslationsAddonsKnobsEn._(
    _root,
  );
  late final TranslationsAddonsLocalizationEn localization =
      TranslationsAddonsLocalizationEn._(_root);
  late final TranslationsAddonsOrderingEn ordering =
      TranslationsAddonsOrderingEn._(_root);
  late final TranslationsAddonsColorPickerEn colorPicker =
      TranslationsAddonsColorPickerEn._(_root);
  late final TranslationsAddonsDescriptionEn description =
      TranslationsAddonsDescriptionEn._(_root);
  late final TranslationsAddonsPageTransitionEn pageTransition =
      TranslationsAddonsPageTransitionEn._(_root);
  late final TranslationsAddonsRecentHistoryEn recentHistory =
      TranslationsAddonsRecentHistoryEn._(_root);
  late final TranslationsAddonsAcknowledgedEn acknowledged =
      TranslationsAddonsAcknowledgedEn._(_root);
  late final TranslationsAddonsConstraintsEn constraints =
      TranslationsAddonsConstraintsEn._(_root);
  late final TranslationsAddonsWerkbankThemeEn werkbank_theme =
      TranslationsAddonsWerkbankThemeEn._(_root);
  late final TranslationsAddonsThemingEn theming =
      TranslationsAddonsThemingEn._(_root);
  late final TranslationsAddonsZoomEn zoom = TranslationsAddonsZoomEn._(_root);
}

// Path: app
class TranslationsAppEn {
  TranslationsAppEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get duplicatePathErrorTitleMessage => 'Duplicate Paths Found';
  String duplicatePathErrorContentMessageMarkdown({
    required Object duplicatePath,
  }) =>
      'There are multiple folders, components or use cases with the same path:\n${duplicatePath}\n\nRename some nodes such that all the paths are unique.';
}

// Path: navigationPanel
class TranslationsNavigationPanelEn {
  TranslationsNavigationPanelEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String lastUpdated({required Object date}) => 'LAST UPDATED ${date}';
  late final TranslationsNavigationPanelSearchEn search =
      TranslationsNavigationPanelSearchEn._(_root);
  String get overview => 'Overview';
}

// Path: configurationPanel
class TranslationsConfigurationPanelEn {
  TranslationsConfigurationPanelEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String nameCopiedNotificationMessage({required Object name}) =>
      '"${name}" copied to clipboard';
  String get cantConfigureUseCaseInOverview =>
      'Cannot configure the use case when overviewing it.';
  String get noUseCaseSelected => 'No use case selected';
  late final TranslationsConfigurationPanelTabsEn tabs =
      TranslationsConfigurationPanelTabsEn._(_root);
}

// Path: shortcuts
class TranslationsShortcutsEn {
  TranslationsShortcutsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsShortcutsGeneralEn general =
      TranslationsShortcutsGeneralEn._(_root);
  late final TranslationsShortcutsNavigationModeEn navigationMode =
      TranslationsShortcutsNavigationModeEn._(_root);
}

// Path: overview
class TranslationsOverviewEn {
  TranslationsOverviewEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsOverviewOverflowNotificationEn overflow_notification =
      TranslationsOverviewOverflowNotificationEn._(_root);
}

// Path: generic.yesNoSwitch
class TranslationsGenericYesNoSwitchEn {
  TranslationsGenericYesNoSwitchEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get no => 'NO';
  String get yes => 'YES';
}

// Path: generic.onOffSwitch
class TranslationsGenericOnOffSwitchEn {
  TranslationsGenericOnOffSwitchEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get off => 'OFF';
  String get on => 'ON';
}

// Path: addons.accessibility
class TranslationsAddonsAccessibilityEn {
  TranslationsAddonsAccessibilityEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Accessibility';
  late final TranslationsAddonsAccessibilityControlsEn controls =
      TranslationsAddonsAccessibilityControlsEn._(_root);
  late final TranslationsAddonsAccessibilityInspectorEn inspector =
      TranslationsAddonsAccessibilityInspectorEn._(_root);
}

// Path: addons.background
class TranslationsAddonsBackgroundEn {
  TranslationsAddonsBackgroundEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Background';
  late final TranslationsAddonsBackgroundControlsEn controls =
      TranslationsAddonsBackgroundControlsEn._(_root);
}

// Path: addons.debugging
class TranslationsAddonsDebuggingEn {
  TranslationsAddonsDebuggingEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Debugging (Experimental)';
  late final TranslationsAddonsDebuggingControlsEn controls =
      TranslationsAddonsDebuggingControlsEn._(_root);
}

// Path: addons.hotReloadEffect
class TranslationsAddonsHotReloadEffectEn {
  TranslationsAddonsHotReloadEffectEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Hot Reload Effect';
  late final TranslationsAddonsHotReloadEffectControlsEn controls =
      TranslationsAddonsHotReloadEffectControlsEn._(_root);
}

// Path: addons.knobs
class TranslationsAddonsKnobsEn {
  TranslationsAddonsKnobsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Knobs';
  late final TranslationsAddonsKnobsControlsEn controls =
      TranslationsAddonsKnobsControlsEn._(_root);
  late final TranslationsAddonsKnobsKnobsEn knobs =
      TranslationsAddonsKnobsKnobsEn._(_root);
}

// Path: addons.localization
class TranslationsAddonsLocalizationEn {
  TranslationsAddonsLocalizationEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Localization';
  late final TranslationsAddonsLocalizationControlsEn controls =
      TranslationsAddonsLocalizationControlsEn._(_root);
}

// Path: addons.ordering
class TranslationsAddonsOrderingEn {
  TranslationsAddonsOrderingEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Ordering';
  late final TranslationsAddonsOrderingControlsEn controls =
      TranslationsAddonsOrderingControlsEn._(_root);
}

// Path: addons.colorPicker
class TranslationsAddonsColorPickerEn {
  TranslationsAddonsColorPickerEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Color Picker';
  late final TranslationsAddonsColorPickerControlsEn controls =
      TranslationsAddonsColorPickerControlsEn._(_root);
}

// Path: addons.description
class TranslationsAddonsDescriptionEn {
  TranslationsAddonsDescriptionEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String component({required Object name}) => '${name} (Component)';
  String folder({required Object name}) => '${name} (Folder)';
  String get root => '(Root)';
  String get tags => 'Tags';
  String get description => 'Description';
  String get links => 'External Links';
}

// Path: addons.pageTransition
class TranslationsAddonsPageTransitionEn {
  TranslationsAddonsPageTransitionEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Page Transition';
}

// Path: addons.recentHistory
class TranslationsAddonsRecentHistoryEn {
  TranslationsAddonsRecentHistoryEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get homePageComponentTitle => 'Recently Visited';
}

// Path: addons.acknowledged
class TranslationsAddonsAcknowledgedEn {
  TranslationsAddonsAcknowledgedEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get homePageComponentTitle => 'Recently Added';
}

// Path: addons.constraints
class TranslationsAddonsConstraintsEn {
  TranslationsAddonsConstraintsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Constraints';
  late final TranslationsAddonsConstraintsControlsEn controls =
      TranslationsAddonsConstraintsControlsEn._(_root);
  late final TranslationsAddonsConstraintsShortcutsEn shortcuts =
      TranslationsAddonsConstraintsShortcutsEn._(_root);
}

// Path: addons.werkbank_theme
class TranslationsAddonsWerkbankThemeEn {
  TranslationsAddonsWerkbankThemeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Werkbank Theme';
  late final TranslationsAddonsWerkbankThemeControlsEn controls =
      TranslationsAddonsWerkbankThemeControlsEn._(_root);
}

// Path: addons.theming
class TranslationsAddonsThemingEn {
  TranslationsAddonsThemingEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Theming';
  late final TranslationsAddonsThemingControlsEn controls =
      TranslationsAddonsThemingControlsEn._(_root);
}

// Path: addons.zoom
class TranslationsAddonsZoomEn {
  TranslationsAddonsZoomEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Zoom';
  late final TranslationsAddonsZoomControlsEn controls =
      TranslationsAddonsZoomControlsEn._(_root);
  late final TranslationsAddonsZoomShortcutsEn shortcuts =
      TranslationsAddonsZoomShortcutsEn._(_root);
}

// Path: navigationPanel.search
class TranslationsNavigationPanelSearchEn {
  TranslationsNavigationPanelSearchEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get hint => 'Search';
}

// Path: configurationPanel.tabs
class TranslationsConfigurationPanelTabsEn {
  TranslationsConfigurationPanelTabsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get configure => 'CONFIGURE';
  String get inspect => 'INSPECT';
  String get settings => 'SETTINGS';
}

// Path: shortcuts.general
class TranslationsShortcutsGeneralEn {
  TranslationsShortcutsGeneralEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'General';
  String get descriptionSearch => 'Open/Focus search';
  String get descriptionTogglePanel => 'Toggle Panels';
  String get descriptionHome => 'Home';
}

// Path: shortcuts.navigationMode
class TranslationsShortcutsNavigationModeEn {
  TranslationsShortcutsNavigationModeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Navigation Shortcuts';
  String get descriptionPrevious => 'Navigate to the previous use case';
  String get keystrokePrevious => 'Arrow Up / Page Up';
  String get descriptionNext => 'Navigate to the next use case';
  String get keystrokeNext => 'Arrow Down / Page Down';
}

// Path: overview.overflow_notification
class TranslationsOverviewOverflowNotificationEn {
  TranslationsOverviewOverflowNotificationEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Fix Overflows in the Overview';
  String get contentMarkdown =>
      'You seem to be having issues with overflows in the overview.\nThis may be because the thumbnails provide to little space for the widget being displayed.\n\nThere are several ways in which you can control the presentation of the thumbnail,\nincluding setting the scale, which can effectively give the widget more space.\n\nExplore these methods by typing `c.overview.` in your use case\nand autocompleting the methods that are available.\n\nTake a look at the "Overview" topic in the API docs, which explains these methods in detail.';
  String get contentWithConstraintsAddonMarkdown =>
      '${_root.overview.overflow_notification.contentMarkdown}\n\nAdditionally, since you are using the `ConstraintsAddon`, note that the lower bounds given to\n`c.constraints.supported(...)` also set the minimum size that is used for the thumbnail\nunless `limitOverviewSize` is set to `false`.\nAlso by using for example `c.constraints.overview(...)` you can set the view constraints\nthat are used in the overview. If this is not set, the view constraints used in the\noverview falls back to the initial view constraints that are also used when\nviewing the use case.';
}

// Path: addons.accessibility.controls
class TranslationsAddonsAccessibilityControlsEn {
  TranslationsAddonsAccessibilityControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get textScaleFactor => 'Text Scale Factor';
  String get boldText => 'Bold Text';
  late final TranslationsAddonsAccessibilityControlsSemanticsModeEn
  semanticsMode = TranslationsAddonsAccessibilityControlsSemanticsModeEn._(
    _root,
  );
  String get semanticsTree => 'Semantics Tree';
  String get activeSemanticsNode => 'Active Semantics Node';
  late final TranslationsAddonsAccessibilityControlsColorModeEn colorMode =
      TranslationsAddonsAccessibilityControlsColorModeEn._(_root);
}

// Path: addons.accessibility.inspector
class TranslationsAddonsAccessibilityInspectorEn {
  TranslationsAddonsAccessibilityInspectorEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Semantics Inspector';
}

// Path: addons.background.controls
class TranslationsAddonsBackgroundControlsEn {
  TranslationsAddonsBackgroundControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsBackgroundControlsBackgroundEn background =
      TranslationsAddonsBackgroundControlsBackgroundEn._(_root);
}

// Path: addons.debugging.controls
class TranslationsAddonsDebuggingControlsEn {
  TranslationsAddonsDebuggingControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get performanceOverlay => 'Performance Overlay';
  String get paintBaselines => 'Paint Baselines';
  String get paintSize => 'Paint Size';
  String get repaintTextRainbow => 'Repaint Text Rainbow';
  String get repaintRainbow => 'Repaint Rainbow';
  String get timeDilation => 'Time Dilation';
}

// Path: addons.hotReloadEffect.controls
class TranslationsAddonsHotReloadEffectControlsEn {
  TranslationsAddonsHotReloadEffectControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get hotReloadEffect => 'Hot Reload Effect';
}

// Path: addons.knobs.controls
class TranslationsAddonsKnobsControlsEn {
  TranslationsAddonsKnobsControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsKnobsControlsPresetEn preset =
      TranslationsAddonsKnobsControlsPresetEn._(_root);
}

// Path: addons.knobs.knobs
class TranslationsAddonsKnobsKnobsEn {
  TranslationsAddonsKnobsKnobsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsKnobsKnobsBooleanEn boolean =
      TranslationsAddonsKnobsKnobsBooleanEn._(_root);
  late final TranslationsAddonsKnobsKnobsIntervalEn interval =
      TranslationsAddonsKnobsKnobsIntervalEn._(_root);
  late final TranslationsAddonsKnobsKnobsFocusnodeEn focusnode =
      TranslationsAddonsKnobsKnobsFocusnodeEn._(_root);
}

// Path: addons.localization.controls
class TranslationsAddonsLocalizationControlsEn {
  TranslationsAddonsLocalizationControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get locale => 'Locale';
}

// Path: addons.ordering.controls
class TranslationsAddonsOrderingControlsEn {
  TranslationsAddonsOrderingControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsOrderingControlsOrderEn order =
      TranslationsAddonsOrderingControlsOrderEn._(_root);
}

// Path: addons.colorPicker.controls
class TranslationsAddonsColorPickerControlsEn {
  TranslationsAddonsColorPickerControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsColorPickerControlsColorPickerEn colorPicker =
      TranslationsAddonsColorPickerControlsColorPickerEn._(_root);
}

// Path: addons.constraints.controls
class TranslationsAddonsConstraintsControlsEn {
  TranslationsAddonsConstraintsControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsConstraintsControlsPresetEn preset =
      TranslationsAddonsConstraintsControlsPresetEn._(_root);
  late final TranslationsAddonsConstraintsControlsConstraintsEn constraints =
      TranslationsAddonsConstraintsControlsConstraintsEn._(_root);
  late final TranslationsAddonsConstraintsControlsSizeEn size =
      TranslationsAddonsConstraintsControlsSizeEn._(_root);
}

// Path: addons.constraints.shortcuts
class TranslationsAddonsConstraintsShortcutsEn {
  TranslationsAddonsConstraintsShortcutsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Constraints Mode Change Shortcuts';
  String get subTitle => 'Use the ruler to size one axis to tight constraints';
  String get descriptionResize => 'Resize both axes to tight constraints';
  String get descriptionMinSize => 'Apply minimum size constraints';
  String get descriptionMaxSize => 'Apply maximum size constraints';
}

// Path: addons.werkbank_theme.controls
class TranslationsAddonsWerkbankThemeControlsEn {
  TranslationsAddonsWerkbankThemeControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get theme => 'Theme';
}

// Path: addons.theming.controls
class TranslationsAddonsThemingControlsEn {
  TranslationsAddonsThemingControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get theme => 'Theme';
}

// Path: addons.zoom.controls
class TranslationsAddonsZoomControlsEn {
  TranslationsAddonsZoomControlsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get enabled => 'Enabled';
  String get magnification => 'Magnification';
}

// Path: addons.zoom.shortcuts
class TranslationsAddonsZoomShortcutsEn {
  TranslationsAddonsZoomShortcutsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Zoom/Pan Shortcuts';
  String get descriptionZoom => 'Zoom in and out';
  String get keystrokeZoom => 'Mouse Wheel';
  String get descriptionReset => 'Reset zoom';
  String get descriptionZoomIn => 'Zoom in';
  String get descriptionZoomOut => 'Zoom out';
  String get descriptionPan => 'Pan the view';
  String get keystrokePan => 'Left or Middle Mouse Button Drag';
  String get descriptionZoomPan => 'Zoom/Pan the view';
  String get keystrokeZoomPan => 'Zoom/Pan gestures on Trackpad';
}

// Path: addons.accessibility.controls.semanticsMode
class TranslationsAddonsAccessibilityControlsSemanticsModeEn {
  TranslationsAddonsAccessibilityControlsSemanticsModeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Semantics Mode';
  late final TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn
  values = TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn._(
    _root,
  );
}

// Path: addons.accessibility.controls.colorMode
class TranslationsAddonsAccessibilityControlsColorModeEn {
  TranslationsAddonsAccessibilityControlsColorModeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Simulated Color Blindness';
  late final TranslationsAddonsAccessibilityControlsColorModeValuesEn values =
      TranslationsAddonsAccessibilityControlsColorModeValuesEn._(_root);
}

// Path: addons.background.controls.background
class TranslationsAddonsBackgroundControlsBackgroundEn {
  TranslationsAddonsBackgroundControlsBackgroundEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get label => 'Background';
  late final TranslationsAddonsBackgroundControlsBackgroundValuesEn values =
      TranslationsAddonsBackgroundControlsBackgroundValuesEn._(_root);
}

// Path: addons.knobs.controls.preset
class TranslationsAddonsKnobsControlsPresetEn {
  TranslationsAddonsKnobsControlsPresetEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Preset';
  late final TranslationsAddonsKnobsControlsPresetValuesEn values =
      TranslationsAddonsKnobsControlsPresetValuesEn._(_root);
}

// Path: addons.knobs.knobs.boolean
class TranslationsAddonsKnobsKnobsBooleanEn {
  TranslationsAddonsKnobsKnobsBooleanEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAddonsKnobsKnobsBooleanValuesEn values =
      TranslationsAddonsKnobsKnobsBooleanValuesEn._(_root);
}

// Path: addons.knobs.knobs.interval
class TranslationsAddonsKnobsKnobsIntervalEn {
  TranslationsAddonsKnobsKnobsIntervalEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get begin => 'Begin';
  String get end => 'End';
}

// Path: addons.knobs.knobs.focusnode
class TranslationsAddonsKnobsKnobsFocusnodeEn {
  TranslationsAddonsKnobsKnobsFocusnodeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get unfocused => 'Unfocused';
  String get focused => 'Focused';
}

// Path: addons.ordering.controls.order
class TranslationsAddonsOrderingControlsOrderEn {
  TranslationsAddonsOrderingControlsOrderEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Order';
  late final TranslationsAddonsOrderingControlsOrderValuesEn values =
      TranslationsAddonsOrderingControlsOrderValuesEn._(_root);
}

// Path: addons.colorPicker.controls.colorPicker
class TranslationsAddonsColorPickerControlsColorPickerEn {
  TranslationsAddonsColorPickerControlsColorPickerEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Color Picker';
  late final TranslationsAddonsColorPickerControlsColorPickerValuesEn values =
      TranslationsAddonsColorPickerControlsColorPickerValuesEn._(_root);
}

// Path: addons.constraints.controls.preset
class TranslationsAddonsConstraintsControlsPresetEn {
  TranslationsAddonsConstraintsControlsPresetEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Preset';
  late final TranslationsAddonsConstraintsControlsPresetValuesEn values =
      TranslationsAddonsConstraintsControlsPresetValuesEn._(_root);
}

// Path: addons.constraints.controls.constraints
class TranslationsAddonsConstraintsControlsConstraintsEn {
  TranslationsAddonsConstraintsControlsConstraintsEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Constraints';
  late final TranslationsAddonsConstraintsControlsConstraintsValuesEn values =
      TranslationsAddonsConstraintsControlsConstraintsValuesEn._(_root);
}

// Path: addons.constraints.controls.size
class TranslationsAddonsConstraintsControlsSizeEn {
  TranslationsAddonsConstraintsControlsSizeEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Size';
  late final TranslationsAddonsConstraintsControlsSizeValuesEn values =
      TranslationsAddonsConstraintsControlsSizeValuesEn._(_root);
}

// Path: addons.accessibility.controls.semanticsMode.values
class TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn {
  TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get none => 'None';
  String get overlay => 'Overlay';
  String get inspection => 'Inspection';
}

// Path: addons.accessibility.controls.colorMode.values
class TranslationsAddonsAccessibilityControlsColorModeValuesEn {
  TranslationsAddonsAccessibilityControlsColorModeValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get none => 'None';
  String get protanopia => 'Protanopia (red blindness)';
  String get deuteranopia => 'Deuteranopia (green blindness)';
  String get tritanopia => 'Tritanopia (blue blindness)';
  String get protanomaly => 'Protanomaly (red weakness)';
  String get deuteranomaly => 'Deuteranomaly (green weakness)';
  String get tritanomaly => 'Tritanomaly (blue weakness)';
  String get inverted => 'Inverted';
  String get grayscale => 'Grayscale';
}

// Path: addons.background.controls.background.values
class TranslationsAddonsBackgroundControlsBackgroundValuesEn {
  TranslationsAddonsBackgroundControlsBackgroundValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get useCaseDefault => 'Use Case Default';
}

// Path: addons.knobs.controls.preset.values
class TranslationsAddonsKnobsControlsPresetValuesEn {
  TranslationsAddonsKnobsControlsPresetValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get initial => 'Initial';
  String get unknown => '-';
}

// Path: addons.knobs.knobs.boolean.values
class TranslationsAddonsKnobsKnobsBooleanValuesEn {
  TranslationsAddonsKnobsKnobsBooleanValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get falseLabel => 'FALSE';
  String get trueLabel => 'TRUE';
}

// Path: addons.ordering.controls.order.values
class TranslationsAddonsOrderingControlsOrderValuesEn {
  TranslationsAddonsOrderingControlsOrderValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get code => 'Code';
  String get alphabetical => 'Alphabetical';
}

// Path: addons.colorPicker.controls.colorPicker.values
class TranslationsAddonsColorPickerControlsColorPickerValuesEn {
  TranslationsAddonsColorPickerControlsColorPickerValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get color => 'Color';
  String get noSelectedColor => 'No color selected';
  String get colorCopied => 'Hex Code copied to clipboard';
  String get pickedColor => 'Picked Color';
}

// Path: addons.constraints.controls.preset.values
class TranslationsAddonsConstraintsControlsPresetValuesEn {
  TranslationsAddonsConstraintsControlsPresetValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get initial => 'Initial';
  String get unknown => '-';
}

// Path: addons.constraints.controls.constraints.values
class TranslationsAddonsConstraintsControlsConstraintsValuesEn {
  TranslationsAddonsConstraintsControlsConstraintsValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get minWidth => 'Min Width';
  String get maxWidth => 'Max Width';
  String get minHeight => 'Min Height';
  String get maxHeight => 'Max Height';
}

// Path: addons.constraints.controls.size.values
class TranslationsAddonsConstraintsControlsSizeValuesEn {
  TranslationsAddonsConstraintsControlsSizeValuesEn._(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get width => 'Width';
  String get height => 'Height';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
  dynamic _flatMapFunction(String path) {
    switch (path) {
      case 'generic.yesNoSwitch.no':
        return 'NO';
      case 'generic.yesNoSwitch.yes':
        return 'YES';
      case 'generic.onOffSwitch.off':
        return 'OFF';
      case 'generic.onOffSwitch.on':
        return 'ON';
      case 'addons.accessibility.name':
        return 'Accessibility';
      case 'addons.accessibility.controls.textScaleFactor':
        return 'Text Scale Factor';
      case 'addons.accessibility.controls.boldText':
        return 'Bold Text';
      case 'addons.accessibility.controls.semanticsMode.name':
        return 'Semantics Mode';
      case 'addons.accessibility.controls.semanticsMode.values.none':
        return 'None';
      case 'addons.accessibility.controls.semanticsMode.values.overlay':
        return 'Overlay';
      case 'addons.accessibility.controls.semanticsMode.values.inspection':
        return 'Inspection';
      case 'addons.accessibility.controls.semanticsTree':
        return 'Semantics Tree';
      case 'addons.accessibility.controls.activeSemanticsNode':
        return 'Active Semantics Node';
      case 'addons.accessibility.controls.colorMode.name':
        return 'Simulated Color Blindness';
      case 'addons.accessibility.controls.colorMode.values.none':
        return 'None';
      case 'addons.accessibility.controls.colorMode.values.protanopia':
        return 'Protanopia (red blindness)';
      case 'addons.accessibility.controls.colorMode.values.deuteranopia':
        return 'Deuteranopia (green blindness)';
      case 'addons.accessibility.controls.colorMode.values.tritanopia':
        return 'Tritanopia (blue blindness)';
      case 'addons.accessibility.controls.colorMode.values.protanomaly':
        return 'Protanomaly (red weakness)';
      case 'addons.accessibility.controls.colorMode.values.deuteranomaly':
        return 'Deuteranomaly (green weakness)';
      case 'addons.accessibility.controls.colorMode.values.tritanomaly':
        return 'Tritanomaly (blue weakness)';
      case 'addons.accessibility.controls.colorMode.values.inverted':
        return 'Inverted';
      case 'addons.accessibility.controls.colorMode.values.grayscale':
        return 'Grayscale';
      case 'addons.accessibility.inspector.name':
        return 'Semantics Inspector';
      case 'addons.background.name':
        return 'Background';
      case 'addons.background.controls.background.label':
        return 'Background';
      case 'addons.background.controls.background.values.useCaseDefault':
        return 'Use Case Default';
      case 'addons.debugging.name':
        return 'Debugging (Experimental)';
      case 'addons.debugging.controls.performanceOverlay':
        return 'Performance Overlay';
      case 'addons.debugging.controls.paintBaselines':
        return 'Paint Baselines';
      case 'addons.debugging.controls.paintSize':
        return 'Paint Size';
      case 'addons.debugging.controls.repaintTextRainbow':
        return 'Repaint Text Rainbow';
      case 'addons.debugging.controls.repaintRainbow':
        return 'Repaint Rainbow';
      case 'addons.debugging.controls.timeDilation':
        return 'Time Dilation';
      case 'addons.hotReloadEffect.name':
        return 'Hot Reload Effect';
      case 'addons.hotReloadEffect.controls.hotReloadEffect':
        return 'Hot Reload Effect';
      case 'addons.knobs.name':
        return 'Knobs';
      case 'addons.knobs.controls.preset.name':
        return 'Preset';
      case 'addons.knobs.controls.preset.values.initial':
        return 'Initial';
      case 'addons.knobs.controls.preset.values.unknown':
        return '-';
      case 'addons.knobs.knobs.boolean.values.falseLabel':
        return 'FALSE';
      case 'addons.knobs.knobs.boolean.values.trueLabel':
        return 'TRUE';
      case 'addons.knobs.knobs.interval.begin':
        return 'Begin';
      case 'addons.knobs.knobs.interval.end':
        return 'End';
      case 'addons.knobs.knobs.focusnode.unfocused':
        return 'Unfocused';
      case 'addons.knobs.knobs.focusnode.focused':
        return 'Focused';
      case 'addons.localization.name':
        return 'Localization';
      case 'addons.localization.controls.locale':
        return 'Locale';
      case 'addons.ordering.name':
        return 'Ordering';
      case 'addons.ordering.controls.order.name':
        return 'Order';
      case 'addons.ordering.controls.order.values.code':
        return 'Code';
      case 'addons.ordering.controls.order.values.alphabetical':
        return 'Alphabetical';
      case 'addons.colorPicker.name':
        return 'Color Picker';
      case 'addons.colorPicker.controls.colorPicker.name':
        return 'Color Picker';
      case 'addons.colorPicker.controls.colorPicker.values.color':
        return 'Color';
      case 'addons.colorPicker.controls.colorPicker.values.noSelectedColor':
        return 'No color selected';
      case 'addons.colorPicker.controls.colorPicker.values.colorCopied':
        return 'Hex Code copied to clipboard';
      case 'addons.colorPicker.controls.colorPicker.values.pickedColor':
        return 'Picked Color';
      case 'addons.description.component':
        return ({required Object name}) => '${name} (Component)';
      case 'addons.description.folder':
        return ({required Object name}) => '${name} (Folder)';
      case 'addons.description.root':
        return '(Root)';
      case 'addons.description.tags':
        return 'Tags';
      case 'addons.description.description':
        return 'Description';
      case 'addons.description.links':
        return 'External Links';
      case 'addons.pageTransition.name':
        return 'Page Transition';
      case 'addons.recentHistory.homePageComponentTitle':
        return 'Recently Visited';
      case 'addons.acknowledged.homePageComponentTitle':
        return 'Recently Added';
      case 'addons.constraints.name':
        return 'Constraints';
      case 'addons.constraints.controls.preset.name':
        return 'Preset';
      case 'addons.constraints.controls.preset.values.initial':
        return 'Initial';
      case 'addons.constraints.controls.preset.values.unknown':
        return '-';
      case 'addons.constraints.controls.constraints.name':
        return 'Constraints';
      case 'addons.constraints.controls.constraints.values.minWidth':
        return 'Min Width';
      case 'addons.constraints.controls.constraints.values.maxWidth':
        return 'Max Width';
      case 'addons.constraints.controls.constraints.values.minHeight':
        return 'Min Height';
      case 'addons.constraints.controls.constraints.values.maxHeight':
        return 'Max Height';
      case 'addons.constraints.controls.size.name':
        return 'Size';
      case 'addons.constraints.controls.size.values.width':
        return 'Width';
      case 'addons.constraints.controls.size.values.height':
        return 'Height';
      case 'addons.constraints.shortcuts.title':
        return 'Constraints Mode Change Shortcuts';
      case 'addons.constraints.shortcuts.subTitle':
        return 'Use the ruler to size one axis to tight constraints';
      case 'addons.constraints.shortcuts.descriptionResize':
        return 'Resize both axes to tight constraints';
      case 'addons.constraints.shortcuts.descriptionMinSize':
        return 'Apply minimum size constraints';
      case 'addons.constraints.shortcuts.descriptionMaxSize':
        return 'Apply maximum size constraints';
      case 'addons.werkbank_theme.name':
        return 'Werkbank Theme';
      case 'addons.werkbank_theme.controls.theme':
        return 'Theme';
      case 'addons.theming.name':
        return 'Theming';
      case 'addons.theming.controls.theme':
        return 'Theme';
      case 'addons.zoom.name':
        return 'Zoom';
      case 'addons.zoom.controls.enabled':
        return 'Enabled';
      case 'addons.zoom.controls.magnification':
        return 'Magnification';
      case 'addons.zoom.shortcuts.title':
        return 'Zoom/Pan Shortcuts';
      case 'addons.zoom.shortcuts.descriptionZoom':
        return 'Zoom in and out';
      case 'addons.zoom.shortcuts.keystrokeZoom':
        return 'Mouse Wheel';
      case 'addons.zoom.shortcuts.descriptionReset':
        return 'Reset zoom';
      case 'addons.zoom.shortcuts.descriptionZoomIn':
        return 'Zoom in';
      case 'addons.zoom.shortcuts.descriptionZoomOut':
        return 'Zoom out';
      case 'addons.zoom.shortcuts.descriptionPan':
        return 'Pan the view';
      case 'addons.zoom.shortcuts.keystrokePan':
        return 'Left or Middle Mouse Button Drag';
      case 'addons.zoom.shortcuts.descriptionZoomPan':
        return 'Zoom/Pan the view';
      case 'addons.zoom.shortcuts.keystrokeZoomPan':
        return 'Zoom/Pan gestures on Trackpad';
      case 'app.duplicatePathErrorTitleMessage':
        return 'Duplicate Paths Found';
      case 'app.duplicatePathErrorContentMessageMarkdown':
        return ({required Object duplicatePath}) =>
            'There are multiple folders, components or use cases with the same path:\n${duplicatePath}\n\nRename some nodes such that all the paths are unique.';
      case 'navigationPanel.lastUpdated':
        return ({required Object date}) => 'LAST UPDATED ${date}';
      case 'navigationPanel.search.hint':
        return 'Search';
      case 'navigationPanel.overview':
        return 'Overview';
      case 'configurationPanel.nameCopiedNotificationMessage':
        return ({required Object name}) => '"${name}" copied to clipboard';
      case 'configurationPanel.cantConfigureUseCaseInOverview':
        return 'Cannot configure the use case when overviewing it.';
      case 'configurationPanel.noUseCaseSelected':
        return 'No use case selected';
      case 'configurationPanel.tabs.configure':
        return 'CONFIGURE';
      case 'configurationPanel.tabs.inspect':
        return 'INSPECT';
      case 'configurationPanel.tabs.settings':
        return 'SETTINGS';
      case 'shortcuts.general.title':
        return 'General';
      case 'shortcuts.general.descriptionSearch':
        return 'Open/Focus search';
      case 'shortcuts.general.descriptionTogglePanel':
        return 'Toggle Panels';
      case 'shortcuts.general.descriptionHome':
        return 'Home';
      case 'shortcuts.navigationMode.title':
        return 'Navigation Shortcuts';
      case 'shortcuts.navigationMode.descriptionPrevious':
        return 'Navigate to the previous use case';
      case 'shortcuts.navigationMode.keystrokePrevious':
        return 'Arrow Up / Page Up';
      case 'shortcuts.navigationMode.descriptionNext':
        return 'Navigate to the next use case';
      case 'shortcuts.navigationMode.keystrokeNext':
        return 'Arrow Down / Page Down';
      case 'overview.overflow_notification.title':
        return 'Fix Overflows in the Overview';
      case 'overview.overflow_notification.contentMarkdown':
        return 'You seem to be having issues with overflows in the overview.\nThis may be because the thumbnails provide to little space for the widget being displayed.\n\nThere are several ways in which you can control the presentation of the thumbnail,\nincluding setting the scale, which can effectively give the widget more space.\n\nExplore these methods by typing `c.overview.` in your use case\nand autocompleting the methods that are available.\n\nTake a look at the "Overview" topic in the API docs, which explains these methods in detail.';
      case 'overview.overflow_notification.contentWithConstraintsAddonMarkdown':
        return '${_root.overview.overflow_notification.contentMarkdown}\n\nAdditionally, since you are using the `ConstraintsAddon`, note that the lower bounds given to\n`c.constraints.supported(...)` also set the minimum size that is used for the thumbnail\nunless `limitOverviewSize` is set to `false`.\nAlso by using for example `c.constraints.overview(...)` you can set the view constraints\nthat are used in the overview. If this is not set, the view constraints used in the\noverview falls back to the initial view constraints that are also used when\nviewing the use case.';
      default:
        return null;
    }
  }
}
