import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class HighlightEventProvider extends StatelessWidget {
  HighlightEventProvider({
    super.key,
    this.highlightStream,
    required this.child,
  }) : assert(
         highlightStream?.isBroadcast ?? true,
         'highlightStream must be a broadcast stream',
       );

  static Stream<List<LocalKey>>? maybeOf(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_Inherited>();
    assert(inherited != null, 'No HighlightEventProvider found in context');
    return inherited!.highlightStream;
  }

  final Stream<List<LocalKey>>? highlightStream;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Inherited(
      highlightStream: highlightStream,
      child: child,
    );
  }
}

class _Inherited extends InheritedWidget {
  const _Inherited({
    required this.highlightStream,
    required super.child,
  });

  final Stream<List<LocalKey>>? highlightStream;

  @override
  bool updateShouldNotify(covariant _Inherited oldWidget) {
    return highlightStream != oldWidget.highlightStream;
  }
}
