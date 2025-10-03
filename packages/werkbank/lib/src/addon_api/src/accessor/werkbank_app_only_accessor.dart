/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// A mixin that provides access to data in the [BuildContext] that is
/// available inside a [WerkbankApp].
mixin WerkbankAppOnlyAccessor on AddonAccessor {
  // TODO(lzuttermeister): Can we do this cleaner?
  _MaybeWerkbankAppAccessor get _maybeAccess =>
      _MaybeWerkbankAppAccessor(containerName);

  /// Gets the [RootDescriptor] of the current [WerkbankApp].
  RootDescriptor rootDescriptorOf(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeRootDescriptorOf(context));
  }

  /// Returns a map of all [UseCaseDescriptor]s to their [UseCaseMetadata]s.
  Map<UseCaseDescriptor, UseCaseMetadata> metadataMapOf(
    BuildContext context,
  ) {
    return ensureNotNull(_maybeAccess.maybeMetadataMapOf(context));
  }

  /// Gets the [UseCaseMetadata] of the given [UseCaseDescriptor].
  UseCaseMetadata metadataForUseCaseOf(
    BuildContext context,
    UseCaseDescriptor useCase,
  ) {
    return ensureNotNull(
      _maybeAccess.maybeMetadataForUseCaseOf(context, useCase),
    );
  }

  /// Gets the [WerkbankRouter] for the current [WerkbankApp].
  WerkbankRouter routerOf(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeRouterOf(context));
  }

  /// Gets the current [NavState] of the current [WerkbankApp].
  NavState navStateOf(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeNavStateOf(context));
  }

  /// Reads the current [NavState] of the current [WerkbankApp] without
  /// creating a dependency.
  NavState readNavStateOf(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeReadNavStateOf(context));
  }

  /// Gets the name of the current [WerkbankApp].
  String werkbankNameOf(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeWerkbankNameOf(context));
  }

  /// Gets the logo of the current [WerkbankApp].
  Widget? logoOf(BuildContext context) {
    return _maybeAccess.maybeLogoOf(context);
  }

  /// Gets the last updated date of the current [WerkbankApp].
  DateTime? lastUpdatedOf(BuildContext context) {
    return _maybeAccess.maybeLastUpdatedOf(context);
  }

  /// Gets the [HistoryController] of the current [WerkbankApp].
  HistoryController historyOf(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeHistoryOf(context));
  }

  /// Gets the [AcknowledgedController] of the current [WerkbankApp].
  AcknowledgedController acknowledgedController(BuildContext context) {
    return ensureNotNull(_maybeAccess.maybeAcknowledgedController(context));
  }

  // TODO: Move out of "app only" accessor.
  /// Gets the [GlobalStateController] of the given type.
  T persistentControllerOf<T extends GlobalStateController>(
    BuildContext context,
  ) {
    return ensureNotNull(_maybeAccess.maybePersistentControllerOf<T>(context));
  }

  /* TODO(lzuttermeister): Should we also add this to
       MaybeWerkbankAppAccessor? */
  /// Subscribes to errors that are reported to [FlutterError.reportError].
  StreamSubscription<FlutterErrorDetails> subscribeToErrors(
    BuildContext context,
    void Function(FlutterErrorDetails errorDetails) onError,
  ) {
    return FlutterErrorProvider.listen(context, onError);
  }
}

class _MaybeWerkbankAppAccessor extends AddonAccessor
    with MaybeWerkbankAppAccessor {
  const _MaybeWerkbankAppAccessor(this.containerName);

  @override
  final String containerName;
}
