import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/use_case_viewport_scale.dart';
import 'package:werkbank/src/_internal/src/widgets/src/use_case_viewport_size.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class UseCaseViewport extends StatelessWidget {
  const UseCaseViewport({
    super.key,
    required this.sizePadding,
    required this.child,
  });

  final EdgeInsets sizePadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = UseCaseViewportScale.of(context);
        var size = (sizePadding / scale).deflateSize(constraints.biggest);
        size = Size(
          max(size.width, 0),
          max(size.height, 0),
        );
        return UseCaseViewportSize(
          size: size,
          child: OverflowBox(
            minWidth: 0,
            maxWidth: double.infinity,
            minHeight: 0,
            maxHeight: double.infinity,
            // We wrap this in a Builder to minimize the widgets that need to be
            // rebuilt when the viewport transform changes.
            child: Builder(
              builder: (context) {
                // It is important that there are no RenderObjects between the
                // Transform and the OverflowBox, since the Transform widget
                // allows hit testing outside its bounds.
                // For example wrapping a SizedBox here, would prevent hits
                // outside the untransformed bounds of the child.
                // Flutters InteractiveViewer uses the same trick.
                return Transform(
                  transform: UseCaseViewportTransform.of(context),
                  alignment: Alignment.center,
                  child: child,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
