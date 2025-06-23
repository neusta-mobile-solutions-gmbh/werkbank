import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class MappingValueListenableBuilder<T, R> extends StatefulWidget {
  const MappingValueListenableBuilder({
    super.key,
    required this.valueListenable,
    required this.mapper,
    required this.builder,
    this.child,
  });

  final ValueListenable<T> valueListenable;
  final R Function(T value) mapper;

  final ValueWidgetBuilder<R> builder;

  final Widget? child;

  @override
  State<MappingValueListenableBuilder<T, R>> createState() =>
      _MappingValueListenableBuilderState();
}

class _MappingValueListenableBuilderState<T, R>
    extends State<MappingValueListenableBuilder<T, R>> {
  late R value;

  @override
  void initState() {
    super.initState();
    value = widget.mapper(widget.valueListenable.value);
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(MappingValueListenableBuilder<T, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.mapper(widget.valueListenable.value);
      widget.valueListenable.addListener(_valueChanged);
    } else if (oldWidget.mapper != widget.mapper) {
      value = widget.mapper(widget.valueListenable.value);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    final newValue = widget.mapper(widget.valueListenable.value);
    if (newValue != value) {
      setState(() {
        value = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
