/// @docImport 'package:werkbank/src/widgets/widgets.dart';
library;

import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entries.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/utils/utils.dart';

typedef AddonLayerWidgetBuilder =
    Widget Function(
      BuildContext context,
      Widget child,
    );

@immutable
class AddonLayerEntry {
  const AddonLayerEntry({
    required this.id,
    required this.appOnly,
    required this.includeInOverlay,
    required this.before,
    required this.after,
    required this.sortHint,
    required this.builder,
  });

  /// A string that uniquely identifies this layer within the addon it is used
  /// in.
  ///
  /// So different addons can define layers with the same [id] without
  /// causing problems.
  final String id;

  /// Whether this entry should only be inserted only when in the context of a
  /// [WerkbankApp].
  /// So if the use case is displayed for example by a
  /// [UseCaseDisplay], this layer will not be inserted.
  ///
  /// For more fine grained control of how widgets are built depending on
  /// whether they are in a [WerkbankApp] or not,
  /// use [AddonLayerAccessor.environmentOf] to get the current environment.
  final bool appOnly;

  // TODO(lzuttermeister): Should we move this to a separate class or mixin?
  /// Whether this entry should be inserted when the use case is displayed
  /// as the thumbnail in the overview.
  ///
  /// This is not applicable in every [AddonLayer], since not every layer
  /// is displayed within the main view where the overview is shown.
  /// If this is not applicable, this is set to `true`.
  ///
  /// For more fine grained control of how widgets are built depending on
  /// whether they are in the overview or not,
  /// use [UseCaseAccessorMixin.maybeUseCaseEnvironmentOf] to get the
  /// current [UseCaseEnvironment].
  final bool includeInOverlay;

  /// Ensures that this [AddonLayerEntry] is inserted before the
  /// [AddonLayerEntry]s identified by the given [FullLayerEntryId]s.
  ///
  /// [FullLayerEntryId]s that refer to no existing layers have no effect.
  ///
  /// {@template werkbank.no_before_after_within_addon}
  /// It is unnecessary to specify relationships between [AddonLayerEntry]s
  /// of the same addon, since they are already guaranteed to be sorted
  /// in the order they are defined.
  /// {@endtemplate}
  final List<FullLayerEntryId> before;

  /// Ensures that this [AddonLayerEntry] is inserted after
  /// the [AddonLayerEntry]s identified by the given [FullLayerEntryId]s.
  ///
  /// {@macro werkbank.no_before_after_within_addon}
  final List<FullLayerEntryId> after;

  /// Gives a hint approximately where within the layer this [AddonLayerEntry]
  /// should be inserted.
  ///
  /// This is only meant to give a rough positioning hint.
  /// If this [AddonLayerEntry] needs to be positioned exactly before or after a
  /// certain [AddonLayerEntry] of another addon, use [before] or [after]
  /// respectively.
  /// Therefore usually the constants [SortHint.beforeMost],
  /// [SortHint.central] and [SortHint.afterMost] should be used.
  ///
  /// The [sortHint] only causes an [AddonLayerEntry] to be sorted
  /// before or after another [AddonLayerEntry] if they do not belong
  /// to the same addon and have not positioned themselves relative
  /// to each other using [before] or [after].
  final SortHint sortHint;
  final AddonLayerWidgetBuilder builder;
}

@immutable
class FullLayerEntryId {
  const FullLayerEntryId({
    required this.addonId,
    required this.entryId,
  });

  final String addonId;
  final String entryId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FullLayerEntryId &&
          runtimeType == other.runtimeType &&
          addonId == other.addonId &&
          entryId == other.entryId;

  @override
  int get hashCode => Object.hash(addonId, entryId);

  @override
  String toString() => '$addonId/$entryId';
}
