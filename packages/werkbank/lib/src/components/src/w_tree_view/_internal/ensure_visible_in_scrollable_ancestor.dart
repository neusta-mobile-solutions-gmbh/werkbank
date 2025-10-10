import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<void> ensureVisibleInScrollableAncestor(
  BuildContext context, {
  Duration duration = Durations.medium2,
  Curve curve = Curves.ease,
  double overScrollOffset = 104,
}) async {
  final position = Scrollable.maybeOf(context)?.position;
  if (position == null) {
    return;
  }
  final object = context.findRenderObject()!;
  assert(
    object.attached,
    'The target RenderObject must be attached to the render tree.',
  );
  final viewport = RenderAbstractViewport.maybeOf(
    object,
  );
  if (viewport == null) {
    return;
  }

  double? scrollTarget;
  var bottomRevealOffset =
      viewport
          .getOffsetToReveal(
            object,
            1,
            axis: position.axis,
          )
          .offset +
      overScrollOffset;
  bottomRevealOffset = clampDouble(
    bottomRevealOffset,
    position.minScrollExtent,
    position.maxScrollExtent,
  );
  if (bottomRevealOffset > position.pixels) {
    scrollTarget = bottomRevealOffset;
  } else {
    var topRevealOffset =
        viewport
            .getOffsetToReveal(
              object,
              0,
              axis: position.axis,
            )
            .offset -
        overScrollOffset;
    topRevealOffset = clampDouble(
      topRevealOffset,
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (topRevealOffset < position.pixels) {
      scrollTarget = topRevealOffset;
    }
  }

  if (scrollTarget == null) {
    return;
  }

  if (duration == Duration.zero) {
    position.jumpTo(scrollTarget);
    return;
  }

  await position.animateTo(scrollTarget, duration: duration, curve: curve);
}
