import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/widgets/widgets.dart';

/// A mixin that provides access to data in the [BuildContext] that is
/// available if they are built inside a [WerkbankApp].
/// The methods in this mixin will return `null` if the widget is not built
/// inside a [WerkbankApp] but for example in a [UseCaseDisplay].
///
/// Implementers of accessors should only use this mixin if there is a
/// possibility that the widget is built outside of a [WerkbankApp].
/// If the widget is exclusively built inside a [WerkbankApp] they should
/// use the [WerkbankAppOnlyAccessor] mixin,
/// which includes all the data from this mixin but without the
/// return type being nullable.
mixin MaybeWerkbankAppAccessor on AddonAccessor {
  /// Gets the [RootDescriptor] of the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@template werkbank.null_in_use_case_display}
  /// If the widget of this [context] is not built inside a [WerkbankApp],
  /// for example because a use case is displayed inside
  /// a [UseCaseDisplay],
  /// this method will return `null`.
  ///
  /// Users of this method should always gracefully handle the `null` case
  /// Otherwise addons may break inside of a [UseCaseDisplay].
  /// {@endtemplate}
  RootDescriptor? maybeRootDescriptorOf(BuildContext context) {
    return ensureReturns(
      () => WerkbankAppInfo.maybeOf(context)?.rootDescriptor,
    );
  }

  /// Returns a map of all [UseCaseDescriptor]s to their [UseCaseMetadata]s
  /// if we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  Map<UseCaseDescriptor, UseCaseMetadata>? maybeMetadataMapOf(
    BuildContext context,
  ) {
    return ensureReturns(
      () => UseCaseMetadataProvider.maybeMetadataMapOf(context),
    );
  }

  /// Gets the [UseCaseMetadata] of the given [UseCaseDescriptor] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  UseCaseMetadata? maybeMetadataForUseCaseOf(
    BuildContext context,
    UseCaseDescriptor useCase,
  ) {
    return ensureReturns(
      () => UseCaseMetadataProvider.maybeMetadataForUseCaseOf(context, useCase),
    );
  }

  /// Gets the [WerkbankRouter] for the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  WerkbankRouter? maybeRouterOf(BuildContext context) {
    return ensureReturns(() => WerkbankRouter.maybeOf(context));
  }

  /// Gets the current [NavState] if we are currently in the context of a
  /// [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  NavState? maybeNavStateOf(BuildContext context) {
    return ensureReturns(() => NavStateProvider.maybeOf(context));
  }

  /// Reads the current [NavState] without creating a dependency
  /// if we are currently in the context of a
  /// [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  NavState? maybeReadNavStateOf(BuildContext context) {
    return ensureReturns(() => NavStateProvider.maybeReadOf(context));
  }

  /// Gets the name of the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  String? maybeWerkbankNameOf(BuildContext context) {
    return ensureReturns(() => WerkbankAppInfo.maybeOf(context)?.name);
  }

  /// Gets the logo of the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  Widget? maybeLogoOf(BuildContext context) {
    return ensureReturns(() => WerkbankAppInfo.maybeOf(context)?.logo);
  }

  /// Gets the last updated date of the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  DateTime? maybeLastUpdatedOf(BuildContext context) {
    return ensureReturns(
      () => WerkbankAppInfo.maybeOf(context)?.lastUpdated,
    );
  }

  /// Gets the [HistoryController] of the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.controller_available_in_app}
  /// {@macro werkbank.null_in_use_case_display}
  HistoryController? maybeHistoryOf(BuildContext context) {
    return ensureReturns(() => WerkbankPersistence.maybeHistoryOf(context));
  }

  /// Gets the [AcknowledgedController] of the current [WerkbankApp] if
  /// we are currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.controller_available_in_app}
  /// {@macro werkbank.null_in_use_case_display}
  AcknowledgedController? maybeAcknowledgedController(BuildContext context) {
    return ensureReturns(
      () => WerkbankPersistence.maybeAcknowledgedController(context),
    );
  }

  /// Gets the [GlobalStateController] of the given type
  /// if we are currently in the
  /// context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  T? maybePersistentControllerOf<T extends GlobalStateController>(
    BuildContext context,
  ) {
    return ensureReturns(
      () => WerkbankPersistence.maybeControllerOf<T>(context),
    );
  }
}
