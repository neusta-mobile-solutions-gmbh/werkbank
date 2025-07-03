import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Werkbank Components}
class WCollapsableHeight extends StatefulWidget {
  const WCollapsableHeight({
    this.collapsedHeight = 200,
    this.duration = Durations.medium1,
    this.curve = Curves.easeInOutSine,
    required this.child,
    super.key,
  });

  final double collapsedHeight;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  State<WCollapsableHeight> createState() => _WCollapsableHeightState();
}

class _WCollapsableHeightState extends State<WCollapsableHeight>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final GlobalKey _sizeKey = GlobalKey();
  double? recentHeight;

  void toggleExpand() {
    recentHeight = _sizeKey.currentContext?.size?.height;
    switch (controller.status) {
      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        controller.forward();

      case AnimationStatus.forward:
      case AnimationStatus.completed:
        controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = CurveTween(curve: widget.curve).animate(controller);
  }

  @override
  void didUpdateWidget(covariant WCollapsableHeight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.curve != widget.curve) {
      controller.duration = widget.duration;
      animation = CurveTween(curve: widget.curve).animate(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColor = context.werkbankColorScheme.field;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        ClipRect(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final t = animation.value;
              final height = recentHeight != null
                  ? lerpDouble(widget.collapsedHeight, recentHeight, t)
                  : widget.collapsedHeight;
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height ?? double.infinity,
                ),
                child: child,
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
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final t = animation.value;
                final gradientAlpha = lerpDouble(255, 0, t)!.toInt();
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientColor.withAlpha(0),
                        gradientColor.withAlpha(
                          gradientAlpha,
                        ),
                      ],
                      begin: const Alignment(0, -.2),
                      end: const Alignment(0, .8),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: toggleExpand,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) => _Chevron(
                    t: animation.value,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
        width: width,
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
