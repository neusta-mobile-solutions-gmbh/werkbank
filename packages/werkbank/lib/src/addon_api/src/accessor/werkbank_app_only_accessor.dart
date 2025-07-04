import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

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

  /// Gets the [PersistentController] of the given type.
  T persistentControllerOf<T extends PersistentController>(
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
