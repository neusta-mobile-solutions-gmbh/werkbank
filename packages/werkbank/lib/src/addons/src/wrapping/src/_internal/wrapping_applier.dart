import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/wrapping/src/_internal/wrapping_state_entry.dart';
import 'package:werkbank/src/addons/src/wrapping/wrapping.dart';

class WrappingApplier extends StatefulWidget {
  const WrappingApplier({
    super.key,
    required this.layer,
    required this.access,
    required this.child,
  });

  final WrappingLayer layer;
  final UseCaseAccessorMixin access;
  final Widget child;

  @override
  State<WrappingApplier> createState() => _WrappingApplierState();
}

class _WrappingApplierState extends State<WrappingApplier> {
  // We must add a global key to the child so that adding or removing
  // wrappers from the use case using a hot reload does not cause the state
  // of children to get lost.
  // The state of more deeply nested wrappers may still get lost, but that
  // is the intended behavior.
  // The only other alternative would be to identify the wrappers using for
  // example a unique name that gets identified with a global key for each
  // wrapper. However that would make use case wrappers more annoying to write
  // and less performant.
  final GlobalKey _childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final composition = widget.access.compositionOf(context);
    final wrappingEntry = composition
        .getTransientStateEntry<WrappingStateEntry>();
    return ListenableBuilder(
      listenable: composition.rebuildListenable,
      builder: (context, child) {
        var result = child!;
        final wrappers = wrappingEntry.getWrappers(widget.layer);
        for (final wrapper in wrappers) {
          final currentResult = result;
          result = Builder(
            builder: (context) {
              return wrapper(context, currentResult);
            },
          );
        }
        return result;
      },
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}
