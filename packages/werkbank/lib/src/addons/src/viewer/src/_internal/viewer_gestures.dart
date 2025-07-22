import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/addons/src/viewer/src/_internal/view_transform.dart';
import 'package:werkbank/src/addons/src/viewer/src/_internal/viewport_reference.dart';
import 'package:werkbank/werkbank.dart';

class ViewerGestures extends StatefulWidget {
  const ViewerGestures({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ViewerGestures> createState() => _ViewerGesturesState();
}

class _ViewerGesturesState extends State<ViewerGestures> {
  static const _minScale = 0.125;
  static const _maxScale = 64.0;

  // A single scroll notch seems to have a delta of 120.
  // The value of 480 ensures that four scroll notches cause a scale factor of
  // 2.
  static const _scrollScaleFactor = 480;
  static const _trackpadScaleExponent = 2;
  static const _pointerScaleExponent = 2;
  static const _shortcutScale = 2.0;

  late final _modifierKeys = context.isApple
      ? {
          LogicalKeyboardKey.metaLeft,
          LogicalKeyboardKey.metaRight,
        }
      : {
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.controlRight,
        };

  final GlobalKey _viewportReferenceKey = GlobalKey();
  final GlobalKey _gestureKey = GlobalKey();

  ViewTransform _transform = ViewTransform.identity;
  bool _isModifierDown = false;
  bool _isScaleActive = false;
  ViewTransform? _prevScaleUpdateRelativeTransform;

  Offset _localToTransform(Offset local) {
    final transformRenderBox =
        _viewportReferenceKey.currentContext!.findRenderObject()! as RenderBox;
    final gestureRenderBox =
        _gestureKey.currentContext!.findRenderObject()! as RenderBox;
    return MatrixUtils.transformPoint(
      PointerEvent.removePerspectiveTransform(
        gestureRenderBox.getTransformTo(transformRenderBox),
      ),
      local,
    );
  }

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  void _resetTransform() {
    setState(() {
      _transform = ViewTransform.identity;
    });
  }

  void _zoomIn() {
    setState(() {
      _transform = _transform.scaled(
        scale: _shortcutScale,
        focalPoint: Offset.zero,
        minScale: _minScale,
        maxScale: _maxScale,
      );
    });
  }

  void _zoomOut() {
    setState(() {
      _transform = _transform.scaled(
        scale: 1 / _shortcutScale,
        focalPoint: Offset.zero,
        minScale: _minScale,
        maxScale: _maxScale,
      );
    });
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (!mounted) {
      return false;
    }
    switch (event) {
      case KeyDownEvent():
        if (_modifierKeys.contains(event.logicalKey)) {
          setState(() {
            _isModifierDown = true;
          });
        }
      case KeyUpEvent():
        if (_modifierKeys.contains(event.logicalKey)) {
          setState(() {
            _isModifierDown = false;
          });
        }
    }
    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final transformedFocalPoint = _localToTransform(details.localFocalPoint);
    setState(() {
      _transform = _transform
          .scaled(
            scale: pow(
              details.scale / _prevScaleUpdateRelativeTransform!.scale,
              _trackpadScaleExponent,
            ).toDouble(),
            focalPoint: transformedFocalPoint,
            minScale: _minScale,
            maxScale: _maxScale,
          )
          .translated(
            transformedFocalPoint - _prevScaleUpdateRelativeTransform!.offset,
          );
    });
    _prevScaleUpdateRelativeTransform = ViewTransform(
      offset: transformedFocalPoint,
      scale: details.scale,
    );
  }

  void _handleScroll(PointerSignalEvent event) {
    if (event is PointerScrollEvent || event is PointerScaleEvent) {
      GestureBinding.instance.pointerSignalResolver.register(
        event,
        (event) {
          final double scale;
          if (event is PointerScrollEvent) {
            final delta = event.scrollDelta;
            scale = pow(2, -delta.dy / _scrollScaleFactor).toDouble();
          } else if (event is PointerScaleEvent) {
            scale = pow(event.scale, _pointerScaleExponent).toDouble();
          } else {
            return;
          }
          final focalPoint = event.localPosition;
          setState(() {
            _transform = _transform.scaled(
              scale: scale,
              focalPoint: _localToTransform(focalPoint),
              minScale: 0.125,
              maxScale: 64,
            );
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recognizeScale = _isModifierDown || _isScaleActive;
    final isApple = context.isApple;
    return GlobalCallbackShortcuts(
      bindings: {
        SingleActivator(
          LogicalKeyboardKey.digit0,
          control: !isApple,
          meta: isApple,
        ): _resetTransform,
        SingleActivator(
          LogicalKeyboardKey.add,
          control: !isApple,
          meta: isApple,
        ): _zoomIn,
        SingleActivator(
          LogicalKeyboardKey.minus,
          control: !isApple,
          meta: isApple,
        ): _zoomOut,
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          UseCaseViewportTransform(
            transform: _transform.toMatrix(),
            child: ViewportReferenceKeyProvider(
              viewportReferenceKey: _viewportReferenceKey,
              child: IgnorePointer(
                ignoring: recognizeScale,
                child: widget.child,
              ),
            ),
          ),
          Positioned.fill(
            child: MouseRegion(
              cursor: _isScaleActive
                  ? SystemMouseCursors.grabbing
                  : (_isModifierDown
                        ? SystemMouseCursors.grab
                        : MouseCursor.defer),
              hitTestBehavior: HitTestBehavior.translucent,
              child: Listener(
                key: _gestureKey,
                behavior: HitTestBehavior.translucent,
                onPointerSignal: _isModifierDown ? _handleScroll : null,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onScaleStart: recognizeScale
                      ? (event) {
                          setState(() => _isScaleActive = true);
                          _prevScaleUpdateRelativeTransform = ViewTransform(
                            offset: _localToTransform(event.localFocalPoint),
                            scale: 1,
                          );
                        }
                      : null,
                  onScaleEnd: recognizeScale
                      ? (_) {
                          setState(() => _isScaleActive = false);
                          _prevScaleUpdateRelativeTransform = null;
                        }
                      : null,
                  onScaleUpdate: recognizeScale ? _handleScaleUpdate : null,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
