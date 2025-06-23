// ignore_for_file: cascade_invocations

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Werkbank Components}
class WNotification extends StatefulWidget {
  const WNotification({
    required this.notification,
    required this.counter,
    required this.onDismiss,
    required this.onPauseVisibility,
    required this.onContinueVisibility,
    required this.onKeepVisible,
    required this.visibilityAnimation,
    super.key,
  });

  final WerkbankNotification notification;
  final int? counter;
  final VoidCallback onDismiss;
  final VoidCallback onPauseVisibility;
  final VoidCallback onContinueVisibility;
  final VoidCallback onKeepVisible;
  final Animation<double>? visibilityAnimation;

  @override
  State<WNotification> createState() => _SNotificationState();
}

class _SNotificationState extends State<WNotification>
    with TickerProviderStateMixin {
  late final AnimationController _counterVisibilityController;
  late final Animation<double> _counterSizeFactor;
  late final Animation<double> _counterOpacity;

  // This is only needed during animating the counter
  // from value to null.
  int? cachedCounter;

  late final AnimationController _expandedController;
  late Animation<double> _expandedAngleFactor;
  late Animation<double> _expandedSizeFactor;
  late Animation<double> _expandedOpacity;

  @override
  void initState() {
    super.initState();
    cachedCounter = widget.counter;

    _counterVisibilityController = AnimationController(
      vsync: this,
      duration: Durations.short4,
      value: widget.counter != null ? 1 : 0,
    );
    _expandedController = AnimationController(
      vsync: this,
      duration: Durations.short4,
      value: 0,
    );
    _initAnimations();
  }

  void _initAnimations() {
    _counterSizeFactor = _counterVisibilityController.drive(
      CurveTween(curve: Curves.easeInOutSine),
    );
    _counterOpacity = _counterSizeFactor.drive(
      CurveTween(
        curve: const Interval(.33, 1),
      ),
    );

    _expandedAngleFactor = _expandedController.drive(
      CurveTween(curve: Curves.easeInOutSine),
    );
    _expandedSizeFactor = _expandedAngleFactor;
    _expandedOpacity = _expandedSizeFactor.drive(
      CurveTween(
        curve: const Interval(.33, 1),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant WNotification oldWidget) {
    super.didUpdateWidget(oldWidget);
    final counterChanged = widget.counter != oldWidget.counter;
    if (counterChanged && widget.counter != null) {
      cachedCounter = widget.counter;
    }
    if (counterChanged) {
      _counterVisibilityController.animateTo(
        widget.counter != null ? 1 : 0,
      );
    }
  }

  void _toggleExpansion() {
    final goForward = switch (_expandedController.status) {
      AnimationStatus.dismissed => true,
      AnimationStatus.forward => false,
      AnimationStatus.reverse => true,
      AnimationStatus.completed => false,
    };
    if (goForward) {
      _expandedController.forward();
    } else {
      _expandedController.reverse();
    }
  }

  @override
  void dispose() {
    _counterVisibilityController.dispose();
    _expandedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.notification.buildBody(context);
    final expandable = body != null;

    const iconSize = 16.0;
    const borderWidth = 2.0;
    const verticalPadding = 8.0;
    const headRowHeight = iconSize + 2 * borderWidth + 2 * verticalPadding;

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      cursor: widget.visibilityAnimation != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (event) {
        widget.onPauseVisibility();
      },
      onExit: (event) {
        widget.onContinueVisibility();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.visibilityAnimation != null
            ? () {
                widget.onKeepVisible();
              }
            : null,
        child: WBorderedBox(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderWidth: 1,
          borderColor: context.werkbankColorScheme.fieldContent,
          backgroundColor: context.werkbankColorScheme.field,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (expandable) ...[
                        WIconButton(
                          onPressed: _toggleExpansion,
                          padding: const EdgeInsets.all(
                            verticalPadding,
                          ),
                          icon: AnimatedBuilder(
                            animation: _expandedAngleFactor,
                            builder: (context, child) => Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.002)
                                ..rotateX(pi * _expandedAngleFactor.value),
                              child: child,
                            ),
                            child: const Icon(
                              WerkbankIcons.caretDown,
                              size: iconSize,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      FadeTransition(
                        opacity: _counterOpacity,
                        child: SizeTransition(
                          sizeFactor: _counterSizeFactor,
                          axis: Axis.horizontal,
                          fixedCrossAxisSizeFactor: 1,
                          child: Container(
                            height: headRowHeight,
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context
                                    .werkbankColorScheme
                                    .backgroundActive,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                (widget.counter ?? cachedCounter).toString(),
                                style: context.werkbankTextTheme.interaction
                                    .apply(
                                      color: context
                                          .werkbankColorScheme
                                          .textActive,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: _counterSizeFactor,
                        axis: Axis.horizontal,
                        fixedCrossAxisSizeFactor: 1,
                        child: const SizedBox(width: 8),
                      ),
                      Expanded(
                        child: DefaultTextStyle.merge(
                          style: context.werkbankTextTheme.defaultText.apply(
                            color: context.werkbankColorScheme.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: widget.notification.buildHead(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _VisibilityDismissButton(
                        animation: widget.visibilityAnimation,
                        onDismiss: widget.onDismiss,
                        iconSize: iconSize,
                        verticalPadding: verticalPadding,
                      ),
                    ],
                  ),
                ),
                if (expandable)
                  Flexible(
                    child: FadeTransition(
                      opacity: _expandedOpacity,
                      child: SizeTransition(
                        sizeFactor: _expandedSizeFactor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: DefaultTextStyle.merge(
                            style: context.werkbankTextTheme.detail.apply(
                              color: context.werkbankColorScheme.text,
                            ),
                            maxLines: 30,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            child: body,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.notification.source != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.notification.source!,
                        style: context.werkbankTextTheme.textSmall.copyWith(
                          color: context.werkbankColorScheme.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VisibilityDismissButton extends StatelessWidget {
  const _VisibilityDismissButton({
    required this.animation,
    required this.onDismiss,
    required this.iconSize,
    required this.verticalPadding,
  });

  final Animation<double>? animation;
  final VoidCallback onDismiss;
  final double iconSize;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final effectiveAnimation = animation ?? const AlwaysStoppedAnimation(0);
    return AnimatedBuilder(
      animation: effectiveAnimation,
      builder: (context, child) => CustomPaint(
        foregroundPainter: _ProgressPainter(
          color: context.werkbankColorScheme.backgroundActive,
          progress: effectiveAnimation.value,
        ),
        child: child,
      ),
      child: WIconButton(
        onPressed: onDismiss,
        padding: EdgeInsets.all(verticalPadding),
        icon: Icon(
          WerkbankIcons.x,
          size: iconSize,
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter({
    required this.color,
    required this.progress,
  });

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const outerRadius = 4.0;
    const thickness = 2.0;
    const cornerRadius = outerRadius - thickness / 2;

    final rect = (Offset.zero & size).deflate(thickness / 2);

    final path = Path();

    path.moveTo(rect.center.dx, rect.top);
    path.lineTo(rect.right - cornerRadius, rect.top);
    path.arcToPoint(
      Offset(rect.right, rect.top + cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(rect.right, rect.bottom - cornerRadius);
    path.arcToPoint(
      Offset(rect.right - cornerRadius, rect.bottom),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(rect.left + cornerRadius, rect.bottom);
    path.arcToPoint(
      Offset(rect.left, rect.bottom - cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(rect.left, rect.top + cornerRadius);
    path.arcToPoint(
      Offset(rect.left + cornerRadius, rect.top),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(rect.center.dx, rect.top);

    final metrics = path.computeMetrics().first;
    final subPath = metrics.extractPath(0, progress * metrics.length);

    canvas.drawPath(
      subPath,
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
