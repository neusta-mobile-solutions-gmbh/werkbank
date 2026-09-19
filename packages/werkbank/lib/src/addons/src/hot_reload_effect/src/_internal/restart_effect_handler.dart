import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/hot_reload_effect/hot_reload_effect.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/environment/environment.dart';

class RestartEffectHandler extends StatefulWidget {
  const RestartEffectHandler({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RestartEffectHandler> createState() => _RestartEffectHandlerState();
}

class _RestartEffectHandlerState extends State<RestartEffectHandler>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller?.forward(from: 0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (initialized) return;
    final withRestartEffect = HotReloadEffectManager.enabledOf(context);
    if (withRestartEffect) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(
          // This must be a long duration,
          // because there is a small
          // jank on app restart
          // that can lead to the
          // first frame being skipped.
          // this is also the reason why
          // there is a tween sequence
          milliseconds: 1500,
        ),
      );

      animation = TweenSequence<double>([
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 0),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: CurveTween(
            curve: HotReloadEffectManager.curve,
          ).chain(Tween<double>(begin: 0, end: 1)),
          weight: 20,
        ),
      ]).animate(controller!);
    }
    initialized = true;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (ManagementLayerEntry.access.environmentOf(context)) {
      case WerkbankEnvironment.app:
        if (controller == null) return widget.child;
        return WHotReloadEffect(
          animation: animation,
          child: widget.child,
        );
      case WerkbankEnvironment.display:
        return widget.child;
    }
  }
}
