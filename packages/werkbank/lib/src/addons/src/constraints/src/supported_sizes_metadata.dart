import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/constraints/src/view_constraints_composer.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/use_case_metadata/use_case_metadata.dart';

class _SupportedSizesMetadataEntry
    extends UseCaseMetadataEntry<_SupportedSizesMetadataEntry> {
  const _SupportedSizesMetadataEntry(this.supportedSizes);

  final BoxConstraints supportedSizes;
}

extension SupportedSizesMetadataExtension on UseCaseMetadata {
  BoxConstraints get supportedSizes =>
      get<_SupportedSizesMetadataEntry>()?.supportedSizes ??
      const BoxConstraints();
}

/// {@category Overview}
extension SupportedSizesComposerExtension on ViewConstraintsComposer {
  UseCaseComposer get _c => this as UseCaseComposer;

  /// Sets the supported constraints for the use case.
  ///
  /// This limits the constraints that can be set by the [ConstraintsAddon].
  /// These limits apply to both setting the constraints manually and
  /// via methods in the [ViewConstraintsComposer]/[ViewConstraintsExtension].
  ///
  /// Calling this method multiple times will merge the constraints with the
  /// previous ones using [BoxConstraints.enforce].
  ///
  /// Unless [limitOverviewSize] is set to false, this methods will also
  /// set the [OverviewComposer.minimumSize] to the minimum size of the
  /// supported constraints.
  void supported(
    BoxConstraints constraints, {
    bool limitOverviewSize = true,
  }) {
    assert(
      constraints.isNormalized,
      'The BoxConstraints for the supportedSizes must be normalized.',
    );
    assert(
      !constraints.hasInfiniteWidth && !constraints.hasInfiniteHeight,
      'The BoxConstraints for the supportedSizes must not force '
      'an infinite width or height.',
    );
    final oldSupportedSizes =
        _c.getMetadata<_SupportedSizesMetadataEntry>()?.supportedSizes ??
        const BoxConstraints();

    _c.setMetadata(
      _SupportedSizesMetadataEntry(constraints.enforce(oldSupportedSizes)),
    );
    if (limitOverviewSize) {
      _c.overview.minimumSize(
        width: constraints.minWidth,
        height: constraints.minHeight,
      );
    }
  }
}
