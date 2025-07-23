import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/persistence/src/werkbank_persistence.dart';

class WasAliveTracker extends StatefulWidget {
  const WasAliveTracker({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<WasAliveTracker> createState() => _WasAliveTrackerState();
}

class _WasAliveTrackerState extends State<WasAliveTracker> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), _onTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _log();
    });
  }

  void _onTick(_) {
    _log();
  }

  void _log() {
    WerkbankPersistence.maybeWasAliveController(context)?.logAppIsAlive();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
