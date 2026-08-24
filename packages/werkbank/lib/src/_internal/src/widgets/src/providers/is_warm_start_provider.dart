import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/persistence/persistence.dart';

class IsWarmStartProvider extends StatefulWidget {
  const IsWarmStartProvider({
    required this.alwaysTreatLikeWarmStart,
    required this.child,
    super.key,
  });

  static bool read(BuildContext context) {
    final result = context
        .getInheritedWidgetOfExactType<_InheritedIsWarmStartProvider>();
    assert(result != null, 'No IsWarmStartProvider found in context');
    return result!.isWarmStart;
  }

  final bool alwaysTreatLikeWarmStart;
  final Widget child;

  @override
  State<IsWarmStartProvider> createState() => _IsWarmStartProviderState();
}

class _IsWarmStartProviderState extends State<IsWarmStartProvider> {
  late final JsonStore jsonStore;
  late final Timer timer;
  late bool isWarmStart;

  static const _persistenceKey = 'werkbank:is_warm_start_timestamp';

  @override
  void initState() {
    super.initState();
    jsonStore = JsonStoreProvider.read(context);
    if (widget.alwaysTreatLikeWarmStart) {
      isWarmStart = true;
    } else {
      final lastShutdownTimestamp = DateTime.tryParse(
        jsonStore.get(_persistenceKey).toString(),
      );
      if (lastShutdownTimestamp != null) {
        final now = DateTime.now().toUtc();
        final difference = now.difference(lastShutdownTimestamp);
        isWarmStart = difference < const Duration(seconds: 20);
        if (isWarmStart) {
          unawaited(
            Future<void>.delayed(difference).then((_) {
              setState(() {
                isWarmStart = false;
              });
            }),
          );
        }
      } else {
        isWarmStart = false;
      }
    }
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _log(),
    );
    _log();
  }

  void _log() {
    final timestamp = DateTime.now().toUtc();
    jsonStore.set(_persistenceKey, timestamp.toIso8601String());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedIsWarmStartProvider(
      isWarmStart: isWarmStart,
      child: widget.child,
    );
  }
}

class _InheritedIsWarmStartProvider extends InheritedWidget {
  const _InheritedIsWarmStartProvider({
    required this.isWarmStart,
    required super.child,
  });

  final bool isWarmStart;

  @override
  bool updateShouldNotify(_InheritedIsWarmStartProvider old) {
    return isWarmStart != old.isWarmStart;
  }
}
