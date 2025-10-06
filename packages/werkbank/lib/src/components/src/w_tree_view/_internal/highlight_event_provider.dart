import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class HighlightEventProvider extends InheritedWidget {
  HighlightEventProvider({
    super.key,
    required this.highlightStream,
    required super.child,
  }) : assert(
         highlightStream?.isBroadcast ?? true,
         'highlightStream must be a broadcast stream',
       );

  static Stream<List<LocalKey>>? maybeOf(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<HighlightEventProvider>();
    assert(inherited != null, 'No HighlightEventProvider found in context');
    return inherited!.highlightStream;
  }

  final Stream<List<LocalKey>>? highlightStream;

  @override
  bool updateShouldNotify(HighlightEventProvider oldWidget) {
    return highlightStream != oldWidget.highlightStream;
  }
}
