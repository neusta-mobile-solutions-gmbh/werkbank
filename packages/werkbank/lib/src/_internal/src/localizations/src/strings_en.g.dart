///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsGenericEn generic = TranslationsGenericEn._(_root);
	late final TranslationsAddonsEn addons = TranslationsAddonsEn._(_root);
	late final TranslationsAppEn app = TranslationsAppEn._(_root);
	late final TranslationsNavigationPanelEn navigationPanel = TranslationsNavigationPanelEn._(_root);
	late final TranslationsConfigurationPanelEn configurationPanel = TranslationsConfigurationPanelEn._(_root);
	late final TranslationsShortcutsEn shortcuts = TranslationsShortcutsEn._(_root);
	late final TranslationsOverviewEn overview = TranslationsOverviewEn._(_root);
}

// Path: generic
class TranslationsGenericEn {
	TranslationsGenericEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsGenericYesNoSwitchEn yesNoSwitch = TranslationsGenericYesNoSwitchEn._(_root);
	late final TranslationsGenericOnOffSwitchEn onOffSwitch = TranslationsGenericOnOffSwitchEn._(_root);
	late final TranslationsGenericShowHideSwitchEn showHideSwitch = TranslationsGenericShowHideSwitchEn._(_root);
}

// Path: addons
class TranslationsAddonsEn {
	TranslationsAddonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsAccessibilityEn accessibility = TranslationsAddonsAccessibilityEn._(_root);
	late final TranslationsAddonsBackgroundEn background = TranslationsAddonsBackgroundEn._(_root);
	late final TranslationsAddonsDebuggingEn debugging = TranslationsAddonsDebuggingEn._(_root);
	late final TranslationsAddonsHotReloadEffectEn hotReloadEffect = TranslationsAddonsHotReloadEffectEn._(_root);
	late final TranslationsAddonsKnobsEn knobs = TranslationsAddonsKnobsEn._(_root);
	late final TranslationsAddonsLocalizationEn localization = TranslationsAddonsLocalizationEn._(_root);
	late final TranslationsAddonsOrderingEn ordering = TranslationsAddonsOrderingEn._(_root);
	late final TranslationsAddonsColorPickerEn colorPicker = TranslationsAddonsColorPickerEn._(_root);
	late final TranslationsAddonsDescriptionEn description = TranslationsAddonsDescriptionEn._(_root);
	late final TranslationsAddonsPageTransitionEn pageTransition = TranslationsAddonsPageTransitionEn._(_root);
	late final TranslationsAddonsRecentHistoryEn recentHistory = TranslationsAddonsRecentHistoryEn._(_root);
	late final TranslationsAddonsAcknowledgedEn acknowledged = TranslationsAddonsAcknowledgedEn._(_root);
	late final TranslationsAddonsConstraintsEn constraints = TranslationsAddonsConstraintsEn._(_root);
	late final TranslationsAddonsWerkbankThemeEn werkbank_theme = TranslationsAddonsWerkbankThemeEn._(_root);
	late final TranslationsAddonsThemingEn theming = TranslationsAddonsThemingEn._(_root);
	late final TranslationsAddonsZoomEn zoom = TranslationsAddonsZoomEn._(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Duplicate Paths Found'
	String get duplicatePathErrorTitleMessage => 'Duplicate Paths Found';

	/// en: 'There are multiple folders, components or use cases with the same path: $duplicatePath Rename some nodes such that all the paths are unique.'
	String duplicatePathErrorContentMessageMarkdown({required Object duplicatePath}) => 'There are multiple folders, components or use cases with the same path:\n${duplicatePath}\n\nRename some nodes such that all the paths are unique.';
}

// Path: navigationPanel
class TranslationsNavigationPanelEn {
	TranslationsNavigationPanelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'LAST UPDATED $date'
	String lastUpdated({required Object date}) => 'LAST UPDATED ${date}';

	late final TranslationsNavigationPanelSearchEn search = TranslationsNavigationPanelSearchEn._(_root);

	/// en: 'Overview'
	String get overview => 'Overview';
}

// Path: configurationPanel
class TranslationsConfigurationPanelEn {
	TranslationsConfigurationPanelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '"$name" copied to clipboard'
	String nameCopiedNotificationMessage({required Object name}) => '"${name}" copied to clipboard';

	/// en: 'Cannot configure the use case when overviewing it.'
	String get cantConfigureUseCaseInOverview => 'Cannot configure the use case when overviewing it.';

	/// en: 'No use case selected'
	String get noUseCaseSelected => 'No use case selected';

	late final TranslationsConfigurationPanelTabsEn tabs = TranslationsConfigurationPanelTabsEn._(_root);
}

// Path: shortcuts
class TranslationsShortcutsEn {
	TranslationsShortcutsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsShortcutsGeneralEn general = TranslationsShortcutsGeneralEn._(_root);
	late final TranslationsShortcutsNavigationModeEn navigationMode = TranslationsShortcutsNavigationModeEn._(_root);
}

// Path: overview
class TranslationsOverviewEn {
	TranslationsOverviewEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsOverviewOverflowNotificationEn overflow_notification = TranslationsOverviewOverflowNotificationEn._(_root);
}

// Path: generic.yesNoSwitch
class TranslationsGenericYesNoSwitchEn {
	TranslationsGenericYesNoSwitchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'NO'
	String get no => 'NO';

	/// en: 'YES'
	String get yes => 'YES';
}

// Path: generic.onOffSwitch
class TranslationsGenericOnOffSwitchEn {
	TranslationsGenericOnOffSwitchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OFF'
	String get off => 'OFF';

	/// en: 'ON'
	String get on => 'ON';
}

// Path: generic.showHideSwitch
class TranslationsGenericShowHideSwitchEn {
	TranslationsGenericShowHideSwitchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'HIDE'
	String get hide => 'HIDE';

	/// en: 'SHOW'
	String get show => 'SHOW';
}

// Path: addons.accessibility
class TranslationsAddonsAccessibilityEn {
	TranslationsAddonsAccessibilityEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Accessibility'
	String get name => 'Accessibility';

	late final TranslationsAddonsAccessibilityControlsEn controls = TranslationsAddonsAccessibilityControlsEn._(_root);
	late final TranslationsAddonsAccessibilityInspectorEn inspector = TranslationsAddonsAccessibilityInspectorEn._(_root);
}

// Path: addons.background
class TranslationsAddonsBackgroundEn {
	TranslationsAddonsBackgroundEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Background'
	String get name => 'Background';

	late final TranslationsAddonsBackgroundControlsEn controls = TranslationsAddonsBackgroundControlsEn._(_root);
}

// Path: addons.debugging
class TranslationsAddonsDebuggingEn {
	TranslationsAddonsDebuggingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Debugging (Experimental)'
	String get name => 'Debugging (Experimental)';

	late final TranslationsAddonsDebuggingControlsEn controls = TranslationsAddonsDebuggingControlsEn._(_root);
}

// Path: addons.hotReloadEffect
class TranslationsAddonsHotReloadEffectEn {
	TranslationsAddonsHotReloadEffectEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hot Reload Effect'
	String get name => 'Hot Reload Effect';

	late final TranslationsAddonsHotReloadEffectControlsEn controls = TranslationsAddonsHotReloadEffectControlsEn._(_root);
}

// Path: addons.knobs
class TranslationsAddonsKnobsEn {
	TranslationsAddonsKnobsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Knobs'
	String get name => 'Knobs';

	late final TranslationsAddonsKnobsControlsEn controls = TranslationsAddonsKnobsControlsEn._(_root);
	late final TranslationsAddonsKnobsKnobsEn knobs = TranslationsAddonsKnobsKnobsEn._(_root);
}

// Path: addons.localization
class TranslationsAddonsLocalizationEn {
	TranslationsAddonsLocalizationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Localization'
	String get name => 'Localization';

	late final TranslationsAddonsLocalizationControlsEn controls = TranslationsAddonsLocalizationControlsEn._(_root);
}

// Path: addons.ordering
class TranslationsAddonsOrderingEn {
	TranslationsAddonsOrderingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ordering'
	String get name => 'Ordering';

	late final TranslationsAddonsOrderingControlsEn controls = TranslationsAddonsOrderingControlsEn._(_root);
}

// Path: addons.colorPicker
class TranslationsAddonsColorPickerEn {
	TranslationsAddonsColorPickerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Color Picker'
	String get name => 'Color Picker';

	late final TranslationsAddonsColorPickerControlsEn controls = TranslationsAddonsColorPickerControlsEn._(_root);
}

// Path: addons.description
class TranslationsAddonsDescriptionEn {
	TranslationsAddonsDescriptionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '$name (Component)'
	String component({required Object name}) => '${name} (Component)';

	/// en: '$name (Folder)'
	String folder({required Object name}) => '${name} (Folder)';

	/// en: '(Root)'
	String get root => '(Root)';

	/// en: 'Tags'
	String get tags => 'Tags';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'External Links'
	String get links => 'External Links';
}

// Path: addons.pageTransition
class TranslationsAddonsPageTransitionEn {
	TranslationsAddonsPageTransitionEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Page Transition'
	String get name => 'Page Transition';
}

// Path: addons.recentHistory
class TranslationsAddonsRecentHistoryEn {
	TranslationsAddonsRecentHistoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recently Visited'
	String get homePageComponentTitle => 'Recently Visited';

	/// en: 'No use cases visited yet.'
	String get noUseCasesVisited => 'No use cases visited yet.';
}

// Path: addons.acknowledged
class TranslationsAddonsAcknowledgedEn {
	TranslationsAddonsAcknowledgedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recently Added'
	String get homePageComponentTitle => 'Recently Added';

	/// en: 'No new use cases added since your last visit.'
	String get noNewUseCases => 'No new use cases added since your last visit.';
}

// Path: addons.constraints
class TranslationsAddonsConstraintsEn {
	TranslationsAddonsConstraintsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Constraints'
	String get name => 'Constraints';

	late final TranslationsAddonsConstraintsControlsEn controls = TranslationsAddonsConstraintsControlsEn._(_root);
	late final TranslationsAddonsConstraintsShortcutsEn shortcuts = TranslationsAddonsConstraintsShortcutsEn._(_root);
}

// Path: addons.werkbank_theme
class TranslationsAddonsWerkbankThemeEn {
	TranslationsAddonsWerkbankThemeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Werkbank Theme'
	String get name => 'Werkbank Theme';

	late final TranslationsAddonsWerkbankThemeControlsEn controls = TranslationsAddonsWerkbankThemeControlsEn._(_root);
	late final TranslationsAddonsWerkbankThemeThemesEn themes = TranslationsAddonsWerkbankThemeThemesEn._(_root);
}

// Path: addons.theming
class TranslationsAddonsThemingEn {
	TranslationsAddonsThemingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theming'
	String get name => 'Theming';

	late final TranslationsAddonsThemingControlsEn controls = TranslationsAddonsThemingControlsEn._(_root);
}

// Path: addons.zoom
class TranslationsAddonsZoomEn {
	TranslationsAddonsZoomEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Zoom'
	String get name => 'Zoom';

	late final TranslationsAddonsZoomControlsEn controls = TranslationsAddonsZoomControlsEn._(_root);
	late final TranslationsAddonsZoomShortcutsEn shortcuts = TranslationsAddonsZoomShortcutsEn._(_root);
}

// Path: navigationPanel.search
class TranslationsNavigationPanelSearchEn {
	TranslationsNavigationPanelSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get hint => 'Search';
}

// Path: configurationPanel.tabs
class TranslationsConfigurationPanelTabsEn {
	TranslationsConfigurationPanelTabsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'CONFIGURE'
	String get configure => 'CONFIGURE';

	/// en: 'INSPECT'
	String get inspect => 'INSPECT';

	/// en: 'SETTINGS'
	String get settings => 'SETTINGS';
}

// Path: shortcuts.general
class TranslationsShortcutsGeneralEn {
	TranslationsShortcutsGeneralEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get title => 'General';

	/// en: 'Open/Focus search'
	String get descriptionSearch => 'Open/Focus search';

	/// en: 'Toggle Panels'
	String get descriptionTogglePanel => 'Toggle Panels';

	/// en: 'Home'
	String get descriptionHome => 'Home';
}

// Path: shortcuts.navigationMode
class TranslationsShortcutsNavigationModeEn {
	TranslationsShortcutsNavigationModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Navigation Shortcuts'
	String get title => 'Navigation Shortcuts';

	/// en: 'Navigate to the previous use case'
	String get descriptionPrevious => 'Navigate to the previous use case';

	/// en: 'Arrow Up / Page Up'
	String get keystrokePrevious => 'Arrow Up / Page Up';

	/// en: 'Navigate to the next use case'
	String get descriptionNext => 'Navigate to the next use case';

	/// en: 'Arrow Down / Page Down'
	String get keystrokeNext => 'Arrow Down / Page Down';
}

// Path: overview.overflow_notification
class TranslationsOverviewOverflowNotificationEn {
	TranslationsOverviewOverflowNotificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Fix Overflows in the Overview'
	String get title => 'Fix Overflows in the Overview';

	/// en: 'You seem to be having issues with overflows in the overview. This may be because the thumbnails provide to little space for the widget being displayed. There are several ways in which you can control the presentation of the thumbnail, including setting the scale, which can effectively give the widget more space. To learn about these, read the [Overview](https://pub.dev/documentation/werkbank/latest/topics/Overview-topic.html) topic in the API docs. Alternatively, explore the methods yourself by typing `c.overview.` in your use case and autocompleting the methods that are available.'
	String get contentMarkdown => 'You seem to be having issues with overflows in the overview.\nThis may be because the thumbnails provide to little space for the widget being displayed.\n\nThere are several ways in which you can control the presentation of the thumbnail,\nincluding setting the scale, which can effectively give the widget more space.\n\nTo learn about these, read the\n[Overview](https://pub.dev/documentation/werkbank/latest/topics/Overview-topic.html)\ntopic in the API docs.\n\nAlternatively, explore the methods yourself by typing `c.overview.` in your use case\nand autocompleting the methods that are available.';

	/// en: 'You seem to be having issues with overflows in the overview. This may be because the thumbnails provide to little space for the widget being displayed. There are several ways in which you can control the presentation of the thumbnail, including setting the scale, which can effectively give the widget more space. To learn about these, read the [Overview](https://pub.dev/documentation/werkbank/latest/topics/Overview-topic.html) topic in the API docs. Alternatively, explore the methods yourself by typing `c.overview.` in your use case and autocompleting the methods that are available. Additionally, since you are using the `ConstraintsAddon`, note that the lower bounds given to `c.constraints.supported(...)` also set the minimum size that is used for the thumbnail unless `limitOverviewSize` is set to `false`. Also by using for example `c.constraints.overview(...)` you can set the view constraints that are used in the overview. If this is not set, the view constraints used in the overview falls back to the initial view constraints that are also used when viewing the use case.'
	String get contentWithConstraintsAddonMarkdown => '${_root.overview.overflow_notification.contentMarkdown}\n\nAdditionally, since you are using the `ConstraintsAddon`, note that the lower bounds given to\n`c.constraints.supported(...)` also set the minimum size that is used for the thumbnail\nunless `limitOverviewSize` is set to `false`.\nAlso by using for example `c.constraints.overview(...)` you can set the view constraints\nthat are used in the overview. If this is not set, the view constraints used in the\noverview falls back to the initial view constraints that are also used when\nviewing the use case.';
}

// Path: addons.accessibility.controls
class TranslationsAddonsAccessibilityControlsEn {
	TranslationsAddonsAccessibilityControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Text Scale Factor'
	String get textScaleFactor => 'Text Scale Factor';

	/// en: 'Bold Text'
	String get boldText => 'Bold Text';

	late final TranslationsAddonsAccessibilityControlsSemanticsModeEn semanticsMode = TranslationsAddonsAccessibilityControlsSemanticsModeEn._(_root);
	late final TranslationsAddonsAccessibilityControlsSplitAxisEn splitAxis = TranslationsAddonsAccessibilityControlsSplitAxisEn._(_root);

	/// en: 'Semantics Tree'
	String get semanticsTree => 'Semantics Tree';

	/// en: 'Active Semantics Node'
	String get activeSemanticsNode => 'Active Semantics Node';

	late final TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeEn semanticsInspectionScope = TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeEn._(_root);

	/// en: 'Merged Nodes'
	String get mergedSemanticsNodes => 'Merged Nodes';

	/// en: 'Hidden Nodes'
	String get hiddenSemanticsNodes => 'Hidden Nodes';

	late final TranslationsAddonsAccessibilityControlsColorModeEn colorMode = TranslationsAddonsAccessibilityControlsColorModeEn._(_root);
}

// Path: addons.accessibility.inspector
class TranslationsAddonsAccessibilityInspectorEn {
	TranslationsAddonsAccessibilityInspectorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Semantics Inspector'
	String get name => 'Semantics Inspector';
}

// Path: addons.background.controls
class TranslationsAddonsBackgroundControlsEn {
	TranslationsAddonsBackgroundControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsBackgroundControlsBackgroundEn background = TranslationsAddonsBackgroundControlsBackgroundEn._(_root);
}

// Path: addons.debugging.controls
class TranslationsAddonsDebuggingControlsEn {
	TranslationsAddonsDebuggingControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Performance Overlay'
	String get performanceOverlay => 'Performance Overlay';

	/// en: 'Paint Baselines'
	String get paintBaselines => 'Paint Baselines';

	/// en: 'Paint Size'
	String get paintSize => 'Paint Size';

	/// en: 'Repaint Text Rainbow'
	String get repaintTextRainbow => 'Repaint Text Rainbow';

	/// en: 'Repaint Rainbow'
	String get repaintRainbow => 'Repaint Rainbow';

	/// en: 'Time Dilation'
	String get timeDilation => 'Time Dilation';
}

// Path: addons.hotReloadEffect.controls
class TranslationsAddonsHotReloadEffectControlsEn {
	TranslationsAddonsHotReloadEffectControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hot Reload Effect'
	String get hotReloadEffect => 'Hot Reload Effect';
}

// Path: addons.knobs.controls
class TranslationsAddonsKnobsControlsEn {
	TranslationsAddonsKnobsControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsKnobsControlsPresetEn preset = TranslationsAddonsKnobsControlsPresetEn._(_root);
}

// Path: addons.knobs.knobs
class TranslationsAddonsKnobsKnobsEn {
	TranslationsAddonsKnobsKnobsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsKnobsKnobsIntervalEn interval = TranslationsAddonsKnobsKnobsIntervalEn._(_root);
	late final TranslationsAddonsKnobsKnobsFocusnodeEn focusnode = TranslationsAddonsKnobsKnobsFocusnodeEn._(_root);
}

// Path: addons.localization.controls
class TranslationsAddonsLocalizationControlsEn {
	TranslationsAddonsLocalizationControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Locale'
	String get locale => 'Locale';
}

// Path: addons.ordering.controls
class TranslationsAddonsOrderingControlsEn {
	TranslationsAddonsOrderingControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsOrderingControlsOrderEn order = TranslationsAddonsOrderingControlsOrderEn._(_root);
}

// Path: addons.colorPicker.controls
class TranslationsAddonsColorPickerControlsEn {
	TranslationsAddonsColorPickerControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsColorPickerControlsColorPickerEn colorPicker = TranslationsAddonsColorPickerControlsColorPickerEn._(_root);
}

// Path: addons.constraints.controls
class TranslationsAddonsConstraintsControlsEn {
	TranslationsAddonsConstraintsControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAddonsConstraintsControlsPresetEn preset = TranslationsAddonsConstraintsControlsPresetEn._(_root);
	late final TranslationsAddonsConstraintsControlsConstraintsEn constraints = TranslationsAddonsConstraintsControlsConstraintsEn._(_root);
	late final TranslationsAddonsConstraintsControlsSizeEn size = TranslationsAddonsConstraintsControlsSizeEn._(_root);
}

// Path: addons.constraints.shortcuts
class TranslationsAddonsConstraintsShortcutsEn {
	TranslationsAddonsConstraintsShortcutsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Constraints Mode Change Shortcuts'
	String get title => 'Constraints Mode Change Shortcuts';

	/// en: 'Use the ruler to size one axis to tight constraints'
	String get subTitle => 'Use the ruler to size one axis to tight constraints';

	/// en: 'Resize both axes to tight constraints'
	String get descriptionResize => 'Resize both axes to tight constraints';

	/// en: 'Apply minimum size constraints'
	String get descriptionMinSize => 'Apply minimum size constraints';

	/// en: 'Apply maximum size constraints'
	String get descriptionMaxSize => 'Apply maximum size constraints';
}

// Path: addons.werkbank_theme.controls
class TranslationsAddonsWerkbankThemeControlsEn {
	TranslationsAddonsWerkbankThemeControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get theme => 'Theme';
}

// Path: addons.werkbank_theme.themes
class TranslationsAddonsWerkbankThemeThemesEn {
	TranslationsAddonsWerkbankThemeThemesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Werkbank System'
	String get system => 'Werkbank System';

	/// en: 'Werkbank Light'
	String get light => 'Werkbank Light';

	/// en: 'Werkbank Dark'
	String get dark => 'Werkbank Dark';
}

// Path: addons.theming.controls
class TranslationsAddonsThemingControlsEn {
	TranslationsAddonsThemingControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: '-'
	String get noTheme => '-';
}

// Path: addons.zoom.controls
class TranslationsAddonsZoomControlsEn {
	TranslationsAddonsZoomControlsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enabled'
	String get enabled => 'Enabled';

	/// en: 'Magnification'
	String get magnification => 'Magnification';
}

// Path: addons.zoom.shortcuts
class TranslationsAddonsZoomShortcutsEn {
	TranslationsAddonsZoomShortcutsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Zoom/Pan Shortcuts'
	String get title => 'Zoom/Pan Shortcuts';

	/// en: 'Zoom in and out'
	String get descriptionZoom => 'Zoom in and out';

	/// en: 'Mouse Wheel'
	String get keystrokeZoom => 'Mouse Wheel';

	/// en: 'Reset zoom'
	String get descriptionReset => 'Reset zoom';

	/// en: 'Zoom in'
	String get descriptionZoomIn => 'Zoom in';

	/// en: 'Zoom out'
	String get descriptionZoomOut => 'Zoom out';

	/// en: 'Pan the view'
	String get descriptionPan => 'Pan the view';

	/// en: 'Left or Middle Mouse Button Drag'
	String get keystrokePan => 'Left or Middle Mouse Button Drag';

	/// en: 'Zoom/Pan the view'
	String get descriptionZoomPan => 'Zoom/Pan the view';

	/// en: 'Zoom/Pan gestures on Trackpad'
	String get keystrokeZoomPan => 'Zoom/Pan gestures on Trackpad';
}

// Path: addons.accessibility.controls.semanticsMode
class TranslationsAddonsAccessibilityControlsSemanticsModeEn {
	TranslationsAddonsAccessibilityControlsSemanticsModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Semantics Mode'
	String get name => 'Semantics Mode';

	late final TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn values = TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn._(_root);
}

// Path: addons.accessibility.controls.splitAxis
class TranslationsAddonsAccessibilityControlsSplitAxisEn {
	TranslationsAddonsAccessibilityControlsSplitAxisEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Split'
	String get name => 'Split';

	late final TranslationsAddonsAccessibilityControlsSplitAxisValuesEn values = TranslationsAddonsAccessibilityControlsSplitAxisValuesEn._(_root);
}

// Path: addons.accessibility.controls.semanticsInspectionScope
class TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeEn {
	TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Inspection Scope'
	String get name => 'Inspection Scope';

	late final TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeValuesEn values = TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeValuesEn._(_root);
}

// Path: addons.accessibility.controls.colorMode
class TranslationsAddonsAccessibilityControlsColorModeEn {
	TranslationsAddonsAccessibilityControlsColorModeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Simulated Color Blindness'
	String get name => 'Simulated Color Blindness';

	late final TranslationsAddonsAccessibilityControlsColorModeValuesEn values = TranslationsAddonsAccessibilityControlsColorModeValuesEn._(_root);
}

// Path: addons.background.controls.background
class TranslationsAddonsBackgroundControlsBackgroundEn {
	TranslationsAddonsBackgroundControlsBackgroundEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Background'
	String get label => 'Background';

	late final TranslationsAddonsBackgroundControlsBackgroundValuesEn values = TranslationsAddonsBackgroundControlsBackgroundValuesEn._(_root);
}

// Path: addons.knobs.controls.preset
class TranslationsAddonsKnobsControlsPresetEn {
	TranslationsAddonsKnobsControlsPresetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Preset'
	String get name => 'Preset';

	late final TranslationsAddonsKnobsControlsPresetValuesEn values = TranslationsAddonsKnobsControlsPresetValuesEn._(_root);
}

// Path: addons.knobs.knobs.interval
class TranslationsAddonsKnobsKnobsIntervalEn {
	TranslationsAddonsKnobsKnobsIntervalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Begin'
	String get begin => 'Begin';

	/// en: 'End'
	String get end => 'End';
}

// Path: addons.knobs.knobs.focusnode
class TranslationsAddonsKnobsKnobsFocusnodeEn {
	TranslationsAddonsKnobsKnobsFocusnodeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unfocused'
	String get unfocused => 'Unfocused';

	/// en: 'Focused'
	String get focused => 'Focused';
}

// Path: addons.ordering.controls.order
class TranslationsAddonsOrderingControlsOrderEn {
	TranslationsAddonsOrderingControlsOrderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Order'
	String get name => 'Order';

	late final TranslationsAddonsOrderingControlsOrderValuesEn values = TranslationsAddonsOrderingControlsOrderValuesEn._(_root);
}

// Path: addons.colorPicker.controls.colorPicker
class TranslationsAddonsColorPickerControlsColorPickerEn {
	TranslationsAddonsColorPickerControlsColorPickerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Color Picker'
	String get name => 'Color Picker';

	late final TranslationsAddonsColorPickerControlsColorPickerValuesEn values = TranslationsAddonsColorPickerControlsColorPickerValuesEn._(_root);
}

// Path: addons.constraints.controls.preset
class TranslationsAddonsConstraintsControlsPresetEn {
	TranslationsAddonsConstraintsControlsPresetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Preset'
	String get name => 'Preset';

	late final TranslationsAddonsConstraintsControlsPresetValuesEn values = TranslationsAddonsConstraintsControlsPresetValuesEn._(_root);
}

// Path: addons.constraints.controls.constraints
class TranslationsAddonsConstraintsControlsConstraintsEn {
	TranslationsAddonsConstraintsControlsConstraintsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Constraints'
	String get name => 'Constraints';

	late final TranslationsAddonsConstraintsControlsConstraintsValuesEn values = TranslationsAddonsConstraintsControlsConstraintsValuesEn._(_root);
}

// Path: addons.constraints.controls.size
class TranslationsAddonsConstraintsControlsSizeEn {
	TranslationsAddonsConstraintsControlsSizeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Size'
	String get name => 'Size';

	late final TranslationsAddonsConstraintsControlsSizeValuesEn values = TranslationsAddonsConstraintsControlsSizeValuesEn._(_root);
}

// Path: addons.accessibility.controls.semanticsMode.values
class TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn {
	TranslationsAddonsAccessibilityControlsSemanticsModeValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'None'
	String get none => 'None';

	/// en: 'Overlay'
	String get overlay => 'Overlay';

	/// en: 'Inspection'
	String get inspection => 'Inspection';

	/// en: 'Side by Side'
	String get sideBySide => 'Side by Side';
}

// Path: addons.accessibility.controls.splitAxis.values
class TranslationsAddonsAccessibilityControlsSplitAxisValuesEn {
	TranslationsAddonsAccessibilityControlsSplitAxisValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Vertical'
	String get vertical => 'Vertical';

	/// en: 'Horizontal'
	String get horizontal => 'Horizontal';
}

// Path: addons.accessibility.controls.semanticsInspectionScope.values
class TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeValuesEn {
	TranslationsAddonsAccessibilityControlsSemanticsInspectionScopeValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Use Case'
	String get useCase => 'Use Case';

	/// en: 'App'
	String get app => 'App';
}

// Path: addons.accessibility.controls.colorMode.values
class TranslationsAddonsAccessibilityControlsColorModeValuesEn {
	TranslationsAddonsAccessibilityControlsColorModeValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'None'
	String get none => 'None';

	/// en: 'Protanopia (red blindness)'
	String get protanopia => 'Protanopia (red blindness)';

	/// en: 'Deuteranopia (green blindness)'
	String get deuteranopia => 'Deuteranopia (green blindness)';

	/// en: 'Tritanopia (blue blindness)'
	String get tritanopia => 'Tritanopia (blue blindness)';

	/// en: 'Protanomaly (red weakness)'
	String get protanomaly => 'Protanomaly (red weakness)';

	/// en: 'Deuteranomaly (green weakness)'
	String get deuteranomaly => 'Deuteranomaly (green weakness)';

	/// en: 'Tritanomaly (blue weakness)'
	String get tritanomaly => 'Tritanomaly (blue weakness)';

	/// en: 'Inverted'
	String get inverted => 'Inverted';

	/// en: 'Grayscale'
	String get grayscale => 'Grayscale';
}

// Path: addons.background.controls.background.values
class TranslationsAddonsBackgroundControlsBackgroundValuesEn {
	TranslationsAddonsBackgroundControlsBackgroundValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Use Case Default'
	String get useCaseDefault => 'Use Case Default';
}

// Path: addons.knobs.controls.preset.values
class TranslationsAddonsKnobsControlsPresetValuesEn {
	TranslationsAddonsKnobsControlsPresetValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Initial'
	String get initial => 'Initial';

	/// en: '-'
	String get unknown => '-';
}

// Path: addons.ordering.controls.order.values
class TranslationsAddonsOrderingControlsOrderValuesEn {
	TranslationsAddonsOrderingControlsOrderValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Code'
	String get code => 'Code';

	/// en: 'Alphabetical'
	String get alphabetical => 'Alphabetical';
}

// Path: addons.colorPicker.controls.colorPicker.values
class TranslationsAddonsColorPickerControlsColorPickerValuesEn {
	TranslationsAddonsColorPickerControlsColorPickerValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Color'
	String get color => 'Color';

	/// en: 'No color selected'
	String get noSelectedColor => 'No color selected';

	/// en: 'Hex Code copied to clipboard'
	String get colorCopied => 'Hex Code copied to clipboard';

	/// en: 'Picked Color'
	String get pickedColor => 'Picked Color';
}

// Path: addons.constraints.controls.preset.values
class TranslationsAddonsConstraintsControlsPresetValuesEn {
	TranslationsAddonsConstraintsControlsPresetValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Initial'
	String get initial => 'Initial';

	/// en: '-'
	String get unknown => '-';
}

// Path: addons.constraints.controls.constraints.values
class TranslationsAddonsConstraintsControlsConstraintsValuesEn {
	TranslationsAddonsConstraintsControlsConstraintsValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Min Width'
	String get minWidth => 'Min Width';

	/// en: 'Max Width'
	String get maxWidth => 'Max Width';

	/// en: 'Min Height'
	String get minHeight => 'Min Height';

	/// en: 'Max Height'
	String get maxHeight => 'Max Height';
}

// Path: addons.constraints.controls.size.values
class TranslationsAddonsConstraintsControlsSizeValuesEn {
	TranslationsAddonsConstraintsControlsSizeValuesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Width'
	String get width => 'Width';

	/// en: 'Height'
	String get height => 'Height';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return _flatMapFunction$0(path);
	}

	dynamic _flatMapFunction$0(String path) {
		return switch (path) {
			'generic.yesNoSwitch.no' => 'NO',
			'generic.yesNoSwitch.yes' => 'YES',
			'generic.onOffSwitch.off' => 'OFF',
			'generic.onOffSwitch.on' => 'ON',
			'generic.showHideSwitch.hide' => 'HIDE',
			'generic.showHideSwitch.show' => 'SHOW',
			'addons.accessibility.name' => 'Accessibility',
			'addons.accessibility.controls.textScaleFactor' => 'Text Scale Factor',
			'addons.accessibility.controls.boldText' => 'Bold Text',
			'addons.accessibility.controls.semanticsMode.name' => 'Semantics Mode',
			'addons.accessibility.controls.semanticsMode.values.none' => 'None',
			'addons.accessibility.controls.semanticsMode.values.overlay' => 'Overlay',
			'addons.accessibility.controls.semanticsMode.values.inspection' => 'Inspection',
			'addons.accessibility.controls.semanticsMode.values.sideBySide' => 'Side by Side',
			'addons.accessibility.controls.splitAxis.name' => 'Split',
			'addons.accessibility.controls.splitAxis.values.vertical' => 'Vertical',
			'addons.accessibility.controls.splitAxis.values.horizontal' => 'Horizontal',
			'addons.accessibility.controls.semanticsTree' => 'Semantics Tree',
			'addons.accessibility.controls.activeSemanticsNode' => 'Active Semantics Node',
			'addons.accessibility.controls.semanticsInspectionScope.name' => 'Inspection Scope',
			'addons.accessibility.controls.semanticsInspectionScope.values.useCase' => 'Use Case',
			'addons.accessibility.controls.semanticsInspectionScope.values.app' => 'App',
			'addons.accessibility.controls.mergedSemanticsNodes' => 'Merged Nodes',
			'addons.accessibility.controls.hiddenSemanticsNodes' => 'Hidden Nodes',
			'addons.accessibility.controls.colorMode.name' => 'Simulated Color Blindness',
			'addons.accessibility.controls.colorMode.values.none' => 'None',
			'addons.accessibility.controls.colorMode.values.protanopia' => 'Protanopia (red blindness)',
			'addons.accessibility.controls.colorMode.values.deuteranopia' => 'Deuteranopia (green blindness)',
			'addons.accessibility.controls.colorMode.values.tritanopia' => 'Tritanopia (blue blindness)',
			'addons.accessibility.controls.colorMode.values.protanomaly' => 'Protanomaly (red weakness)',
			'addons.accessibility.controls.colorMode.values.deuteranomaly' => 'Deuteranomaly (green weakness)',
			'addons.accessibility.controls.colorMode.values.tritanomaly' => 'Tritanomaly (blue weakness)',
			'addons.accessibility.controls.colorMode.values.inverted' => 'Inverted',
			'addons.accessibility.controls.colorMode.values.grayscale' => 'Grayscale',
			'addons.accessibility.inspector.name' => 'Semantics Inspector',
			'addons.background.name' => 'Background',
			'addons.background.controls.background.label' => 'Background',
			'addons.background.controls.background.values.useCaseDefault' => 'Use Case Default',
			'addons.debugging.name' => 'Debugging (Experimental)',
			'addons.debugging.controls.performanceOverlay' => 'Performance Overlay',
			'addons.debugging.controls.paintBaselines' => 'Paint Baselines',
			'addons.debugging.controls.paintSize' => 'Paint Size',
			'addons.debugging.controls.repaintTextRainbow' => 'Repaint Text Rainbow',
			'addons.debugging.controls.repaintRainbow' => 'Repaint Rainbow',
			'addons.debugging.controls.timeDilation' => 'Time Dilation',
			'addons.hotReloadEffect.name' => 'Hot Reload Effect',
			'addons.hotReloadEffect.controls.hotReloadEffect' => 'Hot Reload Effect',
			'addons.knobs.name' => 'Knobs',
			'addons.knobs.controls.preset.name' => 'Preset',
			'addons.knobs.controls.preset.values.initial' => 'Initial',
			'addons.knobs.controls.preset.values.unknown' => '-',
			'addons.knobs.knobs.interval.begin' => 'Begin',
			'addons.knobs.knobs.interval.end' => 'End',
			'addons.knobs.knobs.focusnode.unfocused' => 'Unfocused',
			'addons.knobs.knobs.focusnode.focused' => 'Focused',
			'addons.localization.name' => 'Localization',
			'addons.localization.controls.locale' => 'Locale',
			'addons.ordering.name' => 'Ordering',
			'addons.ordering.controls.order.name' => 'Order',
			'addons.ordering.controls.order.values.code' => 'Code',
			'addons.ordering.controls.order.values.alphabetical' => 'Alphabetical',
			'addons.colorPicker.name' => 'Color Picker',
			'addons.colorPicker.controls.colorPicker.name' => 'Color Picker',
			'addons.colorPicker.controls.colorPicker.values.color' => 'Color',
			'addons.colorPicker.controls.colorPicker.values.noSelectedColor' => 'No color selected',
			'addons.colorPicker.controls.colorPicker.values.colorCopied' => 'Hex Code copied to clipboard',
			'addons.colorPicker.controls.colorPicker.values.pickedColor' => 'Picked Color',
			'addons.description.component' => ({required Object name}) => '${name} (Component)',
			'addons.description.folder' => ({required Object name}) => '${name} (Folder)',
			'addons.description.root' => '(Root)',
			'addons.description.tags' => 'Tags',
			'addons.description.description' => 'Description',
			'addons.description.links' => 'External Links',
			'addons.pageTransition.name' => 'Page Transition',
			'addons.recentHistory.homePageComponentTitle' => 'Recently Visited',
			'addons.recentHistory.noUseCasesVisited' => 'No use cases visited yet.',
			'addons.acknowledged.homePageComponentTitle' => 'Recently Added',
			'addons.acknowledged.noNewUseCases' => 'No new use cases added since your last visit.',
			'addons.constraints.name' => 'Constraints',
			'addons.constraints.controls.preset.name' => 'Preset',
			'addons.constraints.controls.preset.values.initial' => 'Initial',
			'addons.constraints.controls.preset.values.unknown' => '-',
			'addons.constraints.controls.constraints.name' => 'Constraints',
			'addons.constraints.controls.constraints.values.minWidth' => 'Min Width',
			'addons.constraints.controls.constraints.values.maxWidth' => 'Max Width',
			'addons.constraints.controls.constraints.values.minHeight' => 'Min Height',
			'addons.constraints.controls.constraints.values.maxHeight' => 'Max Height',
			'addons.constraints.controls.size.name' => 'Size',
			'addons.constraints.controls.size.values.width' => 'Width',
			'addons.constraints.controls.size.values.height' => 'Height',
			'addons.constraints.shortcuts.title' => 'Constraints Mode Change Shortcuts',
			'addons.constraints.shortcuts.subTitle' => 'Use the ruler to size one axis to tight constraints',
			'addons.constraints.shortcuts.descriptionResize' => 'Resize both axes to tight constraints',
			'addons.constraints.shortcuts.descriptionMinSize' => 'Apply minimum size constraints',
			'addons.constraints.shortcuts.descriptionMaxSize' => 'Apply maximum size constraints',
			'addons.werkbank_theme.name' => 'Werkbank Theme',
			'addons.werkbank_theme.controls.theme' => 'Theme',
			'addons.werkbank_theme.themes.system' => 'Werkbank System',
			'addons.werkbank_theme.themes.light' => 'Werkbank Light',
			'addons.werkbank_theme.themes.dark' => 'Werkbank Dark',
			'addons.theming.name' => 'Theming',
			'addons.theming.controls.theme' => 'Theme',
			'addons.theming.controls.noTheme' => '-',
			'addons.zoom.name' => 'Zoom',
			'addons.zoom.controls.enabled' => 'Enabled',
			'addons.zoom.controls.magnification' => 'Magnification',
			'addons.zoom.shortcuts.title' => 'Zoom/Pan Shortcuts',
			'addons.zoom.shortcuts.descriptionZoom' => 'Zoom in and out',
			'addons.zoom.shortcuts.keystrokeZoom' => 'Mouse Wheel',
			'addons.zoom.shortcuts.descriptionReset' => 'Reset zoom',
			'addons.zoom.shortcuts.descriptionZoomIn' => 'Zoom in',
			'addons.zoom.shortcuts.descriptionZoomOut' => 'Zoom out',
			'addons.zoom.shortcuts.descriptionPan' => 'Pan the view',
			'addons.zoom.shortcuts.keystrokePan' => 'Left or Middle Mouse Button Drag',
			'addons.zoom.shortcuts.descriptionZoomPan' => 'Zoom/Pan the view',
			'addons.zoom.shortcuts.keystrokeZoomPan' => 'Zoom/Pan gestures on Trackpad',
			'app.duplicatePathErrorTitleMessage' => 'Duplicate Paths Found',
			'app.duplicatePathErrorContentMessageMarkdown' => ({required Object duplicatePath}) => 'There are multiple folders, components or use cases with the same path:\n${duplicatePath}\n\nRename some nodes such that all the paths are unique.',
			'navigationPanel.lastUpdated' => ({required Object date}) => 'LAST UPDATED ${date}',
			'navigationPanel.search.hint' => 'Search',
			'navigationPanel.overview' => 'Overview',
			'configurationPanel.nameCopiedNotificationMessage' => ({required Object name}) => '"${name}" copied to clipboard',
			'configurationPanel.cantConfigureUseCaseInOverview' => 'Cannot configure the use case when overviewing it.',
			'configurationPanel.noUseCaseSelected' => 'No use case selected',
			'configurationPanel.tabs.configure' => 'CONFIGURE',
			'configurationPanel.tabs.inspect' => 'INSPECT',
			'configurationPanel.tabs.settings' => 'SETTINGS',
			'shortcuts.general.title' => 'General',
			'shortcuts.general.descriptionSearch' => 'Open/Focus search',
			'shortcuts.general.descriptionTogglePanel' => 'Toggle Panels',
			'shortcuts.general.descriptionHome' => 'Home',
			'shortcuts.navigationMode.title' => 'Navigation Shortcuts',
			'shortcuts.navigationMode.descriptionPrevious' => 'Navigate to the previous use case',
			'shortcuts.navigationMode.keystrokePrevious' => 'Arrow Up / Page Up',
			'shortcuts.navigationMode.descriptionNext' => 'Navigate to the next use case',
			'shortcuts.navigationMode.keystrokeNext' => 'Arrow Down / Page Down',
			'overview.overflow_notification.title' => 'Fix Overflows in the Overview',
			'overview.overflow_notification.contentMarkdown' => 'You seem to be having issues with overflows in the overview.\nThis may be because the thumbnails provide to little space for the widget being displayed.\n\nThere are several ways in which you can control the presentation of the thumbnail,\nincluding setting the scale, which can effectively give the widget more space.\n\nTo learn about these, read the\n[Overview](https://pub.dev/documentation/werkbank/latest/topics/Overview-topic.html)\ntopic in the API docs.\n\nAlternatively, explore the methods yourself by typing `c.overview.` in your use case\nand autocompleting the methods that are available.',
			'overview.overflow_notification.contentWithConstraintsAddonMarkdown' => '${_root.overview.overflow_notification.contentMarkdown}\n\nAdditionally, since you are using the `ConstraintsAddon`, note that the lower bounds given to\n`c.constraints.supported(...)` also set the minimum size that is used for the thumbnail\nunless `limitOverviewSize` is set to `false`.\nAlso by using for example `c.constraints.overview(...)` you can set the view constraints\nthat are used in the overview. If this is not set, the view constraints used in the\noverview falls back to the initial view constraints that are also used when\nviewing the use case.',
			_ => null,
		};
	}
}

