import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/verbose_animation_controller.dart';

class AnimationControllerStatusListenableBuilder extends StatefulWidget {
  const AnimationControllerStatusListenableBuilder({
    required this.animationController,
    required this.builder,
    this.child,
    super.key,
  });

  final VerboseAnimationController animationController;
  final TransitionBuilder builder;
  final Widget? child;

  @override
  State<AnimationControllerStatusListenableBuilder> createState() =>
      _AnimationControllerStatusListenableBuilderState();
}

class _AnimationControllerStatusListenableBuilderState
    extends State<AnimationControllerStatusListenableBuilder> {
  /// See [ListenableBuilder] -> [AnimatedWidget] for reference.
  /// This is a copy of the implementation but it uses
  /// StatusListener instead of ValueListener.
  @override
  void initState() {
    super.initState();
    widget.animationController.addStatusListener(_handleStatusChange);
    widget.animationController.wasStopped.addListener(_handleWasStopped);
  }

  @override
  void didUpdateWidget(AnimationControllerStatusListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationController != oldWidget.animationController) {
      oldWidget.animationController.removeStatusListener(_handleStatusChange);
      oldWidget.animationController.wasStopped.removeListener(
        _handleWasStopped,
      );

      widget.animationController.addStatusListener(_handleStatusChange);
      widget.animationController.wasStopped.addListener(_handleWasStopped);
    }
  }

  @override
  void dispose() {
    widget.animationController.removeStatusListener(_handleStatusChange);
    widget.animationController.wasStopped.removeListener(_handleWasStopped);
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _handleWasStopped() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }
  // ----

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.child);
}
