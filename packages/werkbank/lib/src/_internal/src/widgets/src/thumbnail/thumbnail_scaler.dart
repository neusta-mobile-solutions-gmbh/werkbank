import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class ThumbnailScaler extends StatelessWidget {
  const ThumbnailScaler({
    super.key,
    required this.minSize,
    required this.maxScale,
    required this.viewportPadding,
    required this.child,
  });

  final Size minSize;
  final double maxScale;
  final EdgeInsets viewportPadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = viewportPadding.deflateSize(constraints.biggest);
        final scale = min(
          maxScale,
          min(
            size.width / minSize.width,
            size.height / minSize.height,
          ),
        );
        return SizedBox.expand(
          child: WScaledBox(
            scale: scale,
            child: UseCaseViewportScale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
