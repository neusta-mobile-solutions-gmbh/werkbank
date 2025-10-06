import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/tree/src/descriptor_node.dart';

class NavEventProvider extends StatefulWidget {
  const NavEventProvider({super.key, required this.child});

  final Widget child;

  static Stream<Descriptor> of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_Inherited>();
    assert(inherited != null, 'No NavEventProvider found in context');
    return inherited!.stream;
  }

  @override
  State<NavEventProvider> createState() => _NavEventProviderState();
}

class _NavEventProviderState extends State<NavEventProvider> {
  late final StreamController<Descriptor> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<Descriptor>.broadcast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final navState = NavStateProvider.of(context);
    switch (navState) {
      case HomeNavState():
      case DescriptorNavState(descriptor: RootDescriptor()):
        return;
      case DescriptorNavState(:final ChildDescriptor descriptor):
        _streamController.add(descriptor);
    }
  }

  @override
  void dispose() {
    unawaited(_streamController.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Inherited(stream: _streamController.stream, child: widget.child);
  }
}

class _Inherited extends InheritedWidget {
  const _Inherited({
    required this.stream,
    required super.child,
  });

  final Stream<Descriptor> stream;

  @override
  bool updateShouldNotify(covariant _Inherited oldWidget) {
    return stream != oldWidget.stream;
  }
}
