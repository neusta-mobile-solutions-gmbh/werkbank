import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

/// {@category Werkbank Components}
class WAnimatedVisibility extends ImplicitlyAnimatedWidget {
  const WAnimatedVisibility({
    super.key,
    required this.visible,
    super.onEnd,
    this.axis = Axis.vertical,
    this.disposeInvisible = false,
    this.padding = EdgeInsets.zero,
    super.curve,
    super.duration = Durations.short4,
    required this.child,
  });

  final bool visible;
  final Axis axis;
  final bool disposeInvisible;

  /// A padding that is that is retracted when [visible] is false, but is
  /// visible while the child is animating in or out.
  final EdgeInsets padding;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<WAnimatedVisibility> createState() =>
      _WAnimatedVisibilityState();
}

class _WAnimatedVisibilityState
    extends ImplicitlyAnimatedWidgetState<WAnimatedVisibility> {
  Tween<double>? _sizeFactorTween;
  late Animation<double> _sizeFactorAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _sizeFactorTween =
        visitor(
              _sizeFactorTween,
              widget.visible ? 1.0 : 0.0,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _sizeFactorAnimation = animation.drive(_sizeFactorTween!);
  }

  @override
  Widget build(BuildContext context) {
    final shouldClip = widget.padding != EdgeInsets.zero;
    return ClipRect(
      clipBehavior: shouldClip ? Clip.hardEdge : Clip.none,
      clipper: _PaddedRectClipper(padding: widget.padding),
      child: SizeTransition(
        axis: widget.axis,
        sizeFactor: _sizeFactorAnimation,
        fixedCrossAxisSizeFactor: 1,
        child: Padding(
          padding: widget.padding,
          child: MappingValueListenableBuilder(
            valueListenable: _sizeFactorAnimation,
            mapper: (value) => !widget.disposeInvisible || value != 0,
            builder: (context, isVisible, child) {
              return Visibility(
                visible: isVisible,
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PaddedRectClipper extends CustomClipper<Rect> {
  const _PaddedRectClipper({required this.padding});

  final EdgeInsets padding;

  @override
  Rect getClip(Size size) {
    return padding.deflateRect(Offset.zero & size);
  }

  @override
  bool shouldReclip(_PaddedRectClipper oldClipper) {
    return padding != oldClipper.padding;
  }
}
