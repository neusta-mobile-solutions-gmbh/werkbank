import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class DebugDisplayFilter extends StatefulWidget {
  const DebugDisplayFilter({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<DebugDisplayFilter> createState() => _RootDescripatorArrangerState();
}

class _RootDescripatorArrangerState extends State<DebugDisplayFilter> {
  late FilterResult _filterResult;

  // The widget tree should not be rebuilt
  // just because debugWerkbankFilter changes.
  final GlobalKey _childKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterResult = FilterResultProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: debugWerkbankFilter,
      builder: (context, value, child) {
        final displayDebugText = switch (value) {
          DebugWerkbankFilterDisabled() => false,
          _ => true,
        };
        if (displayDebugText) {
          return Stack(
            children: [
              child!,
              Positioned.fill(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.all(32),
                  child: ColoredBox(
                    color: context.werkbankTheme.colorScheme.background
                        .withValues(alpha: 0.5),
                    child: _DebugText(
                      filterResult: _filterResult,
                      debugWerkbankFilter: value,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return child!;
      },
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}

class _DebugText extends StatelessWidget {
  const _DebugText({
    required this.filterResult,
    required this.debugWerkbankFilter,
  });

  final FilterResult filterResult;
  final DebugWerkbankFilter debugWerkbankFilter;

  @override
  Widget build(BuildContext context) {
    final results = switch (debugWerkbankFilter) {
      DebugWerkbankFilterDisplayMatches() => filterResult.results.where(
        (k, v) => v.isMatch,
      ),
      DebugWerkbankFilterDisplayAllResults() => filterResult.results,
      DebugWerkbankFilterDisabled() => throw UnimplementedError(),
      DebugWerkbankFilterDisplayOnly(childDescriptorNames: final paths) =>
        filterResult.results.where(
          (k, v) =>
              k.node is WerkbankChildNode &&
              paths.contains((k.node as WerkbankChildNode).name),
        ),
    };

    if (!filterResult.filterIsApplied) {
      return const Text('Filter not applied');
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in results.entries)
            Builder(
              builder: (context) {
                const hightlightText = 'isMatch: true';
                final subTexts = entry.value.toString().split(hightlightText);
                return RichText(
                  text: TextSpan(
                    style: context.werkbankTextTheme.defaultText.copyWith(
                      color: context.werkbankColorScheme.text,
                    ),
                    children: [
                      TextSpan(
                        text: switch (entry.key.node) {
                          WerkbankSections() => 'Root',
                          WerkbankChildNode(:final name) => name,
                        },
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      for (final (index, subText) in subTexts.indexed) ...[
                        TextSpan(
                          text: subText,
                        ),
                        if (index < subTexts.length - 1)
                          const TextSpan(
                            text: hightlightText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
