import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlutterErrorProvider extends StatefulWidget {
  const FlutterErrorProvider({super.key, required this.child});

  static StreamSubscription<FlutterErrorDetails> listen(
    BuildContext context,
    void Function(FlutterErrorDetails errorDetails) onError,
  ) {
    final state = context.findAncestorStateOfType<_FlutterErrorProviderState>();
    assert(state != null, 'No FlutterErrorProvider found in the widget tree');
    return state!._errorStreamController.stream.listen(onError);
  }

  final Widget child;

  @override
  State<FlutterErrorProvider> createState() => _FlutterErrorProviderState();
}

class _FlutterErrorProviderState extends State<FlutterErrorProvider> {
  final StreamController<FlutterErrorDetails> _errorStreamController =
      StreamController.broadcast();

  late final FlutterExceptionHandler? prevOnError;
  late final FlutterExceptionHandler ourOnError;

  @override
  void initState() {
    prevOnError = FlutterError.onError;
    FlutterError.onError = ourOnError = (FlutterErrorDetails details) {
      if (!_errorStreamController.isClosed) {
        _errorStreamController.add(details);
      }
      prevOnError?.call(details);
    };
    super.initState();
  }

  @override
  void dispose() {
    // We have to check this. Otherwise we might break other usages
    // that may have modified the error handler.
    // If we cannot remove ourselves, from the error handler, we will stay there
    // forever, but have no effect, since the stream controller is closed.
    if (FlutterError.onError == ourOnError) {
      FlutterError.onError = prevOnError;
    }
    _errorStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
