import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class RulerCorner extends StatelessWidget {
  const RulerCorner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return CustomPaint(
      painter: _RulerCornerPainter(
        surfaceColor: colorScheme.surface,
        dividerColor: colorScheme.divider,
      ),
    );
  }
}

class _RulerCornerPainter extends CustomPainter {
  _RulerCornerPainter({
    required this.surfaceColor,
    required this.dividerColor,
  });

  final Color surfaceColor;
  final Color dividerColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas
      ..drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = surfaceColor,
      )
      ..drawRect(
        Rect.fromLTWH(0, size.height - 1, size.width, 1),
        Paint()..color = dividerColor,
      )
      ..drawRect(
        Rect.fromLTWH(size.width - 1, 0, 1, size.height),
        Paint()..color = dividerColor,
      );
  }

  @override
  bool shouldRepaint(covariant _RulerCornerPainter oldDelegate) {
    return oldDelegate.surfaceColor != surfaceColor ||
        oldDelegate.dividerColor != dividerColor;
  }
}
