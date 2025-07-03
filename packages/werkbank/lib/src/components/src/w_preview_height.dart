import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Werkbank Components}
class WPreviewHeight extends StatefulWidget {
  const WPreviewHeight({
    required this.child,
    this.collapsedHeight = 200,
    super.key,
  });

  final double collapsedHeight;
  final Widget child;

  @override
  State<WPreviewHeight> createState() => _WPreviewHeightState();
}

class _WPreviewHeightState extends State<WPreviewHeight> {
  late bool expand;
  final GlobalKey _sizeKey = GlobalKey();
  double? recentHeight;

  @override
  void initState() {
    super.initState();
    expand = false;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      curve: Curves.easeInOutSine,
      duration: Durations.medium1,
      tween: Tween<double>(begin: expand ? 1 : 0, end: expand ? 1 : 0),
      builder: (context, t, child) {
        final height = recentHeight != null
            ? lerpDouble(widget.collapsedHeight, recentHeight, t)
            : widget.collapsedHeight;
        final gradientAlpha = lerpDouble(255, 0, t)!.toInt();
        return Stack(
          children: [
            ClipRect(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height ?? double.infinity,
                ),
                child: child,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.werkbankColorScheme.field.withAlpha(0),
                        context.werkbankColorScheme.field.withAlpha(
                          gradientAlpha,
                        ),
                      ],
                      begin: const Alignment(0, -.2),
                      end: const Alignment(0, .8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    recentHeight = _sizeKey.currentContext?.size?.height;
                    setState(() {
                      expand = !expand;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _Chevron(
                      t: t,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: OverflowBox(
        maxHeight: double.infinity,
        fit: OverflowBoxFit.deferToChild,
        alignment: Alignment.topCenter,
        child: KeyedSubtree(
          key: _sizeKey,
          child: widget.child,
        ),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({
    required this.t,
  });

  final double t;

  @override
  Widget build(BuildContext context) {
    const width = 32.0;
    const height = 12.0;
    return CustomPaint(
      painter: _Painter(
        width: 32,
        height: lerpDouble(height, -height, t)!,
        color: context.werkbankColorScheme.logo,
      ),
      size: const Size(width, height),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({
    required this.width,
    required this.height,
    required this.color,
  }) : super();

  final double width;
  final double height;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square;

    canvas.drawPath(
      Path()
        ..moveTo(
          size.width * .5 - width * .5,
          size.height * .5 - height * .5,
        )
        ..lineTo(size.width * .5, size.height * .5 + height * .5)
        ..lineTo(
          size.width * .5 + width * .5,
          size.height * .5 - height * .5,
        ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return width != oldDelegate.width ||
        height != oldDelegate.height ||
        color != oldDelegate.color;
  }
}
