import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/use_case/use_case.dart';

/// {@category Overview}
class OverviewSettings extends UseCaseMetadataEntry<OverviewSettings> {
  const OverviewSettings({
    this.minSize = Size.zero,
    this.maxScale,
    this.hasPadding = true,
    this.hasThumbnail = true,
  });

  final Size minSize;
  final double? maxScale;
  final bool hasPadding;
  final bool hasThumbnail;
}

extension OverviewSettingsMetadataExtension on UseCaseMetadata {
  OverviewSettings get overviewSettings =>
      get<OverviewSettings>() ?? const OverviewSettings();
}

/// {@category Overview}
/// An extension type with methods to control the presentation of use cases
/// when they are displayed as a thumbnail in the overview.
extension type OverviewComposer(UseCaseComposer _c) {
  void _merge({
    Size? minSize,
    double? maxScale,
    bool? hasPadding,
    bool? hasThumbnail,
  }) {
    final old = _c.getMetadata<OverviewSettings>() ?? const OverviewSettings();
    _c.setMetadata(
      OverviewSettings(
        minSize: minSize == null
            ? old.minSize
            : Size(
                max(old.minSize.width, minSize.width),
                max(old.minSize.height, minSize.height),
              ),
        maxScale: old.maxScale == null
            ? maxScale
            : (maxScale == null ? old.maxScale : min(old.maxScale!, maxScale)),
        hasPadding: hasPadding ?? old.hasPadding,
        hasThumbnail: hasThumbnail ?? old.hasThumbnail,
      ),
    );
  }

  /// Sets the minimum size of the viewport (excluding the padding)
  /// which is available to the use case when it is
  /// displayed as a thumbnail in the overview.
  /// The thumbnail may then scale the use case smaller so that it effectively
  /// has at least the given amount of space within its own scaled down
  /// coordinate system.
  void minimumSize({double width = 0, double height = 0}) {
    _merge(minSize: Size(width, height));
  }

  /// Sets the maximum scale of the use case when it is
  /// displayed as a thumbnail in the overview.
  /// Setting this to a smaller scale will give the use case effectively more
  /// space in the thumbnail. This can be useful for large widgets.
  /// Setting this to a larger scale will make the use case appear larger in
  /// the thumbnail. This can be useful for small widgets.
  /// If the scale is left unset, the default maximum scale of 1.0 is used.
  void maximumScale(double scale) {
    _merge(maxScale: scale);
  }

  /// Marks the use case as having no padding when it is
  /// displayed as a thumbnail in the overview.
  /// This can look better for widgets that expand themselves to fill the
  /// entire space.
  /// By default, the use case is displayed with padding.
  void withoutPadding() {
    setHasPadding(hasPadding: false);
  }

  /// Sets whether the use case should have padding when it is
  /// displayed as a thumbnail in the overview.
  /// By default, the use case is displayed with padding.
  void setHasPadding({required bool hasPadding}) {
    _merge(hasPadding: hasPadding);
  }

  /// Marks the use case as having no thumbnail in the overview.
  /// Use this when the use case is unfit to be displayed as a thumbnail.
  /// This can for example be the case because it is so large that even
  /// a scaled down version would not look representable of the use case.
  ///
  /// If you want to customize the thumbnail more without disabling it,
  /// you can use [UseCase.isInOverviewOf] within the [WidgetBuilder]
  /// of your use case to check if it currently displayed in the overview and
  /// then customize the returned widget depending on that.
  void withoutThumbnail() {
    _merge(hasThumbnail: false);
  }
}

/// An extension on the [UseCaseComposer] which provides an [overview]
/// getter to access an [OverviewComposer] with several methods to
/// control the presentation of use cases when they are displayed as a
/// thumbnail in the overview.
extension OverviewComposerExtension on UseCaseComposer {
  /// A getter which returns an [OverviewComposer] with several methods to
  /// control the presentation of use cases when they are displayed as a
  /// thumbnail in the overview.
  ///
  /// See [OverviewComposer] and its methods for more information.
  OverviewComposer get overview => OverviewComposer(this);
}
