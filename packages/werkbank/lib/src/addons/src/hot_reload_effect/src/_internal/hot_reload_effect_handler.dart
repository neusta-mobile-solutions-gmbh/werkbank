import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/hot_reload_effect/src/hot_reload_effect_manager.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/environment/environment.dart';

class HotReloadEffectHandler extends StatefulWidget {
  const HotReloadEffectHandler({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<HotReloadEffectHandler> createState() => _HotReloadEffectHandlerState();
}

class _HotReloadEffectHandlerState extends State<HotReloadEffectHandler>
    with
        // Not a Single Ticker, because the AnimationController
        // may gets disposed and recreated
        TickerProviderStateMixin {
  AnimationController? controller;

  bool _appStartupDone = false;

  @override
  void initState() {
    super.initState();

    unawaited(
      Future<void>.delayed(
        // Through testing on different devices, this seems to
        // be a good tradeoff between a short cooldown and a time
        // that is long enough for devices to prevent a second
        // build from triggering the animation.
        const Duration(seconds: 7),
      ).then((_) {
        if (mounted) _appStartupDone = true;
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final withHotReloadEffect = HotReloadEffectManager.enabledOf(context);
    if (withHotReloadEffect && controller == null) {
      controller ??= AnimationController(
        vsync: this,
        duration: Durations.long4,
        value: 1,
      );
    }
    if (!withHotReloadEffect && controller != null) {
      controller?.dispose();
      controller = null;
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (_appStartupDone) {
      controller?.forward(from: 0);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (UseCaseOverlayLayerEntry.access.environmentOf(context)) {
      case WerkbankEnvironment.app:
        return WHotReloadEffect(
          animation: CurveTween(
            curve: HotReloadEffectManager.curve,
          ).animate(controller ?? const AlwaysStoppedAnimation(1)),
          child: widget.child,
        );
      case WerkbankEnvironment.display:
        return widget.child;
    }
  }
}
