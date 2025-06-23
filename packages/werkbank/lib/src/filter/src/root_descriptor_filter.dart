import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class RootDescriptorFilter extends StatefulWidget {
  const RootDescriptorFilter({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RootDescriptorFilter> createState() => _RootDescripatorArrangerState();
}

class _RootDescripatorArrangerState extends State<RootDescriptorFilter>
    with FilterExcecutor {
  late RootDescriptor _rootDescriptor;
  late FilterResult _filterResult;
  SearchQueryController? _controller;

  @override
  String get searchQuery => _controller?.query ?? '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rootDescriptor = WerkbankAppInfo.rootDescriptorOf(context);

    _controller?.removeListener(onChange);
    _controller = WerkbankPersistence.maybeSearchQueryController(context);
    _controller?.addListener(onChange);

    onChange();
  }

  void onChange() {
    setState(() {
      _filterResult = doFilter(
        rootDescriptor: _rootDescriptor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FilterResultProvider(
      filterResult: _filterResult,
      child: widget.child,
    );
  }
}

class FilterResultProvider extends InheritedWidget {
  const FilterResultProvider({
    required this.filterResult,
    required super.child,
    super.key,
  });

  static FilterResult of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FilterResultProvider>()!
        .filterResult;
  }

  final FilterResult filterResult;

  @override
  bool updateShouldNotify(FilterResultProvider oldWidget) {
    final result = filterResult != oldWidget.filterResult;
    return result;
  }
}
