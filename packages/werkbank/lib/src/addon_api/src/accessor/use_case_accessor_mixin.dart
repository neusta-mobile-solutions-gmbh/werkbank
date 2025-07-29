import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/src/accessor/addon_accessor.dart';
import 'package:werkbank/src/addon_api/src/addon_control_sections/tabs/configure_control_section.dart';
import 'package:werkbank/src/addon_api/src/addon_control_sections/tabs/inspect_control_section.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_fitted_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_layout_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/layers/use_case_overlay_layer_entry.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// A mixin that provides access to data in the [BuildContext] that is
/// available from every place where there is a specific use case in the
/// [BuildContext].
///
/// This includes widgets built inside
/// - [UseCaseOverlayLayerEntry]
/// - [UseCaseLayerEntry]
/// - [UseCaseLayoutLayerEntry]
/// - [UseCaseFittedLayerEntry]
/// - [ConfigureControlSection]
/// - [InspectControlSection]
///
/// To obtain an instance of this mixin call the static `access` field on the
/// class listed above from which the widgets you want to access the data
/// in are built.
mixin UseCaseAccessorMixin on AddonAccessor {
  /// Gets the [UseCaseDescriptor] of the current use case.
  UseCaseDescriptor useCaseOf(BuildContext context) =>
      ensureNotNull(ensureReturns(() => DescriptorProvider.useCaseOf(context)));

  /// Gets the [UseCaseMetadata] of the current use case.
  UseCaseMetadata metadataOf(BuildContext context) => ensureReturns(
    () => UseCaseCompositionProvider.metadataOf(context),
  );

  /// Gets the [UseCaseComposition] of the current use case.
  UseCaseComposition compositionOf(
    BuildContext context,
  ) => ensureReturns(
    () => UseCaseCompositionProvider.compositionOf(context),
  );

  /// Gets the [UseCaseEnvironment] of the current use case.
  ///
  /// @macro werkbank.null_in_use_case_display}
  UseCaseEnvironment? maybeUseCaseEnvironmentOf(BuildContext context) =>
      ensureReturns(() => UseCaseEnvironmentProvider.maybeOf(context));
}
