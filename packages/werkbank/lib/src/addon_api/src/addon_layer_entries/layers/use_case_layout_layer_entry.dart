import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class UseCaseLayoutLayerEntry extends AddonLayerEntry {
  const UseCaseLayoutLayerEntry({
    required super.id,
    super.appOnly = false,
    super.includeInOverlay = true,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  });

  static const access = UseCaseLayoutLayerEntryAccessor();
}

class UseCaseLayoutLayerEntryAccessor extends AddonLayerAccessor
    with MaybeWerkbankAppAccessor, UseCaseAccessorMixin {
  const UseCaseLayoutLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseLayoutLayerEntry';

  /// Gets the [Size] of the current viewport of the use case if we are
  /// currently in the context of a [WerkbankApp].
  ///
  /// {@macro werkbank.null_in_use_case_display}
  Size? maybeUseCaseViewportSizeOf(BuildContext context) {
    return UseCaseViewportSize.maybeOf(context);
  }
}
