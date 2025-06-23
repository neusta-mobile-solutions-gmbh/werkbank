import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewConstraints with EquatableMixin {
  const ViewConstraints({
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
  });

  ViewConstraints.fromBoxConstraints(
    BoxConstraints constraints, {
    required bool viewLimitedMaxWidth,
    required bool viewLimitedMaxHeight,
  }) : this(
         minWidth: constraints.minWidth,
         maxWidth: constraints.maxWidth.isInfinite && viewLimitedMaxWidth
             ? null
             : constraints.maxWidth,
         minHeight: constraints.minHeight,
         maxHeight: constraints.maxHeight.isInfinite && viewLimitedMaxHeight
             ? null
             : constraints.maxHeight,
       );

  static const looseViewLimited = ViewConstraints(
    minWidth: 0,
    maxWidth: null,
    minHeight: 0,
    maxHeight: null,
  );

  final double minWidth;
  final double? maxWidth;
  final double minHeight;
  final double? maxHeight;

  BoxConstraints toBoxConstraints({
    required Size viewSize,
  }) {
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth ?? viewSize.width,
      minHeight: minHeight,
      maxHeight: maxHeight ?? viewSize.height,
    ).normalizeWithMaxPriority();
  }

  ViewConstraints enforce(BoxConstraints constraints) {
    return ViewConstraints(
      minWidth: clampDouble(
        minWidth,
        constraints.minWidth,
        constraints.maxWidth,
      ),
      maxWidth: maxWidth == null
          ? null
          : clampDouble(
              maxWidth!,
              constraints.minWidth,
              constraints.maxWidth,
            ),
      minHeight: clampDouble(
        minHeight,
        constraints.minHeight,
        constraints.maxHeight,
      ),
      maxHeight: maxHeight == null
          ? null
          : clampDouble(
              maxHeight!,
              constraints.minHeight,
              constraints.maxHeight,
            ),
    );
  }

  bool get isNormalized {
    return minWidth >= 0.0 &&
        minHeight >= 0.0 &&
        (maxWidth == null || minWidth <= maxWidth!) &&
        (maxHeight == null || minHeight <= maxHeight!);
  }

  ViewConstraints normalizeWithMaxPriority() {
    if (isNormalized) {
      return this;
    }
    final minWidth = this.minWidth >= 0.0 ? this.minWidth : 0.0;
    final minHeight = this.minHeight >= 0.0 ? this.minHeight : 0.0;
    final maxWidth = this.maxWidth == null || this.maxWidth! >= 0.0
        ? this.maxWidth
        : 0.0;
    final maxHeight = this.maxHeight == null || this.maxHeight! >= 0.0
        ? this.maxHeight
        : 0.0;
    return ViewConstraints(
      minWidth: maxWidth == null || minWidth <= maxWidth ? minWidth : maxWidth,
      maxWidth: maxWidth,
      minHeight: maxHeight == null || minHeight <= maxHeight
          ? minHeight
          : maxHeight,
      maxHeight: maxHeight,
    );
  }

  ViewConstraints normalizeWithMinPriority() {
    if (isNormalized) {
      return this;
    }
    final minWidth = this.minWidth >= 0.0 ? this.minWidth : 0.0;
    final minHeight = this.minHeight >= 0.0 ? this.minHeight : 0.0;
    final maxWidth = this.maxWidth == null || this.maxWidth! >= 0.0
        ? this.maxWidth
        : 0.0;
    final maxHeight = this.maxHeight == null || this.maxHeight! >= 0.0
        ? this.maxHeight
        : 0.0;
    return ViewConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth == null || minWidth <= maxWidth ? maxWidth : minWidth,
      minHeight: minHeight,
      maxHeight: maxHeight == null || minHeight <= maxHeight
          ? maxHeight
          : minHeight,
    );
  }

  ViewConstraints limitInfiniteMinByView() {
    return ViewConstraints(
      minWidth: minWidth,
      maxWidth: minWidth.isInfinite ? null : maxWidth,
      minHeight: minHeight,
      maxHeight: minHeight.isInfinite ? null : maxHeight,
    );
  }

  ViewConstraints copyWith({
    double? minWidth,
    double? Function()? maxWidth,
    double? minHeight,
    double? Function()? maxHeight,
  }) {
    return ViewConstraints(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth == null ? this.maxWidth : maxWidth(),
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight == null ? this.maxHeight : maxHeight(),
    );
  }

  @override
  List<Object?> get props => [
    minWidth,
    maxWidth,
    minHeight,
    maxHeight,
  ];
}

extension on BoxConstraints {
  BoxConstraints normalizeWithMaxPriority() {
    if (isNormalized) {
      return this;
    }
    final minWidth = this.minWidth >= 0.0 ? this.minWidth : 0.0;
    final minHeight = this.minHeight >= 0.0 ? this.minHeight : 0.0;
    final maxWidth = this.maxWidth >= 0.0 ? this.maxWidth : 0.0;
    final maxHeight = this.maxHeight >= 0.0 ? this.maxHeight : 0.0;
    return BoxConstraints(
      minWidth: minWidth > maxWidth ? maxWidth : minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight > maxHeight ? maxHeight : minHeight,
      maxHeight: maxHeight,
    );
  }
}
