/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/src/accessor/addon_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/affiliation_transition_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/application_overlay_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/main_view_overlay_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/management_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_fitted_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_layout_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_overlay_layer_entry.dart';
import 'package:werkbank/src/app_config/app_config.dart';
import 'package:werkbank/src/tree/tree.dart';

/// {@category Writing Your Own Addons}
class AddonLayerEntries {
  AddonLayerEntries({
    this.management = const [],
    this.applicationOverlay = const [],
    this.mainViewOverlay = const [],
    this.useCaseOverlay = const [],
    this.affiliationTransition = const [],
    this.useCase = const [],
    this.useCaseLayout = const [],
    this.useCaseFitted = const [],
  });

  final List<ManagementLayerEntry> management;
  final List<ApplicationOverlayLayerEntry> applicationOverlay;
  final List<MainViewOverlayLayerEntry> mainViewOverlay;
  final List<UseCaseOverlayLayerEntry> useCaseOverlay;
  final List<AffiliationTransitionLayerEntry> affiliationTransition;
  final List<UseCaseLayerEntry> useCase;
  final List<UseCaseLayoutLayerEntry> useCaseLayout;
  final List<UseCaseFittedLayerEntry> useCaseFitted;

  List<AddonLayerEntry> entriesByLayer(AddonLayer layer) => switch (layer) {
    AddonLayer.management => management,
    AddonLayer.applicationOverlay => applicationOverlay,
    AddonLayer.mainViewOverlay => mainViewOverlay,
    AddonLayer.useCaseOverlay => useCaseOverlay,
    AddonLayer.affiliationTransition => affiliationTransition,
    AddonLayer.useCase => useCase,
    AddonLayer.useCaseLayout => useCaseLayout,
    AddonLayer.useCaseFitted => useCaseFitted,
  };
}

// TODO(lzuttermeister): Document nesting order in the same layer.
/// The [AddonLayer] describes where in the widget tree the
/// [AddonLayerEntry.builder] is inserted.
///
/// The widgets created by the [AddonLayerEntry.builder]s are wrapped around
/// each other and various other widgets of the [WerkbankApp] or
/// [UseCaseDisplay].
///
/// The nesting order of the layer is defined as follows.
/// Layers with a "*" are only inserted inside a [WerkbankApp] and not
/// inside a [UseCaseDisplay].
/// - [AddonLayer.management]
/// - [AddonLayer.applicationOverlay]*
/// - [AddonLayer.mainViewOverlay]*
/// - [AddonLayer.useCaseOverlay]*
/// - [AddonLayer.affiliationTransition]
/// - [AddonLayer.useCase]
/// - [AddonLayer.useCaseLayout]
/// - [AddonLayer.useCaseFitted]
///
/// Different layers may provide different assurances and impose different
/// requirements on the [AddonLayerEntry.builder].
/// There are some assurances and requirements that hold for all layers.
///
/// ## Assurances for all layers
/// - If two [AddonLayerEntry]s in different layers are both included
///   (inside a [UseCaseDisplay] they could be excluded if they
///   are inside a layer with a "*" in the list above or
///   if they have set [AddonLayerEntry.appOnly] to true),
///   the widgets created by the [AddonLayerEntry.builder] of the layer that
///   is ordered earlier are ancestors of the widgets created by the
///   [AddonLayerEntry.builder] of the layer that is ordered later.
/// - All methods on the static `access` field of the respective
///   [AddonLayerEntry] subclass can be used in the [AddonLayerEntry.builder].
///   The object returned
///   by the `access` field may have different methods depending on the layer.
///   Therefore different layers may have different methods available.
///   See also [AddonAccessor], [AddonLayerAccessor]
///   and [UseCaseAccessorMixin].
///
/// ## Requirements for all layers
/// - The [AddonLayerEntry.builder] must preserve all assurances that it gets.
/// - The [AddonLayerEntry.builder] must build the child exactly once.
/// - The [AddonLayerEntry.builder] must preserve the state of the child
///   as long as its own state is preserved. This means if the child
///   is moved in the widget tree, it needs an appropriate [Key] so that
///   the widget is not rebuilt from scratch.
enum AddonLayer {
  /// The layer that wraps most of the [WerkbankApp].
  /// This layer is typically used for addons to hold an manage their global
  /// state.
  /// Additionally the content can be wrapped with a [WerkbankSettings]
  /// widget to change some settings of the [WerkbankApp].
  ///
  /// ## Requirements
  /// - &#8203;{@template werkbank.no_ui}
  ///   No interactive or visible user interfaces
  ///   must be introduced.{@endtemplate}
  management,

  /// A layer that is wrapped around the whole user interface of the
  /// [WerkbankApp].
  ///
  /// ## Assurances
  /// - Theme and localization of the [WerkbankApp] are available in the
  ///   context.
  /// - The widget receives tight layout constraints.
  applicationOverlay,
  // TODO(lzuttermeister): Document this.
  /// A layer that wraps the main view.
  /// This means if there are multiple use cases visible in an overview,
  /// this is wrapped once around the whole overview.
  ///
  /// ## Assurances
  /// - The widget receives tight layout constraints.
  /// - The widget has the theme and localization of the [WerkbankApp].
  mainViewOverlay,
  // TODO(lzuttermeister): Document this.
  /// A layer that wraps the use case display area.
  /// When viewing multiple use cases in an overview, this is wrapped around
  /// every single one.
  ///
  /// ## Assurances
  /// - The widget receives tight layout constraints.
  /// - The widget has the theme and localization of the [WerkbankApp].
  useCaseOverlay,

  /// This is the layer where widgets transition from belonging to the user
  /// interface of the [WerkbankApp] to the user interface of a use case.
  ///
  /// Widgets in this layer are inserted into the `builder` passed to the
  /// app widget from the [AppConfig], which us passed to the [WerkbankApp]
  /// or [DisplayApp].
  ///
  /// For example this is where the theme and localization is set for the use
  /// case.
  ///
  /// ## Assurances
  /// - The widget receives tight layout constraints.
  ///
  /// ## Requirements
  /// - {@macro werkbank.no_ui}
  affiliationTransition,

  /// This is the first layer that belongs to the user interface of a use case.
  ///
  /// ## Assurances
  /// - &#8203;{@template werkbank.use_case_theme_and_localization}
  ///   The provided theme and localization is that of the
  ///   use case. {@endtemplate}
  /// - The widget receives tight layout constraints.
  ///
  /// ## Requirements
  /// - &#8203;{@template werkbank.no_werkbank_ui}
  ///   No UI elements that conceptually belong to the werkbank
  ///   should be introduced.{@endtemplate}
  useCase,

  /// In this layer the use case can be positioned and its constraints can be
  /// defined.
  ///
  /// ## Assurances
  /// - {@macro werkbank.use_case_theme_and_localization}
  ///
  /// ## Requirements
  /// - {@macro werkbank.no_ui}
  useCaseLayout,

  /// This layer tightly wraps the use case.
  ///
  /// Putting something in this layer is very similar to wrapping the widget
  /// around the widget returned by the [UseCaseBuilder] of a use case.
  ///
  /// ## Assurances
  /// - {@macro werkbank.use_case_theme_and_localization}
  ///
  /// ## Requirements
  /// - {@macro werkbank.no_werkbank_ui}
  useCaseFitted,
}
