import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/filter/filter.dart';
import 'package:werkbank/src/_internal/src/filter/src/_internal/filter_executor.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class RootDescriptorFilter extends StatefulWidget {
  const RootDescriptorFilter({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RootDescriptorFilter> createState() => _RootDescriptorArrangerState();
}

class _RootDescriptorArrangerState extends State<RootDescriptorFilter>
    with FilterExecutor {
  late RootDescriptor _rootDescriptor;
  late FilterResult _filterResult;
  SearchQueryController? _controller;

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
    final searchQuery = _controller?.query ?? '';

    setState(() {
      _filterResult = doFilter(
        searchQuery: searchQuery,
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
