import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WerkbankFolder get searchDemoFolder => WerkbankFolder(
  name: 'Search Demo',
  builder: (context) {
    context.tags(['Giraffe', '🦒']);
  },
  children: [
    WerkbankUseCase(
      name: 'Horse Card',
      builder: searchUseCaseNameUseCase,
    ),
    WerkbankUseCase(
      name: 'Purchase a Car',
      builder: purchaseACarCardUseCase,
    ),
  ],
);

WidgetBuilder searchUseCaseNameUseCase(UseCaseComposer c) {
  c
    ..description(
      'Here we demonstrate what can be found with the search. '
      'How about a horse?',
    )
    ..tags(['Pferd', '🐴', '#10007'])
    ..overview.minimumSize(width: 400);
  final only = _only(c);
  return (context) {
    return _UseCase(
      text: '🐴',
      onlyNames: only.value?.split('\n').toSet() ?? {},
    );
  };
}

WidgetBuilder purchaseACarCardUseCase(UseCaseComposer c) {
  c
    ..tags(['🚗', '#10099'])
    ..overview.minimumSize(width: 400);
  final only = _only(c);
  return (context) {
    return _UseCase(
      text: '🚗',
      onlyNames: only.value?.split('\n').toSet() ?? {},
    );
  };
}

WritableKnob<String?> _only(UseCaseComposer c) {
  return c.knobs.nullable.stringMultiLine(
    'Display Only (use node names)',
    initialValue:
        'WDraggableConstraintedBox'
        '\nPferdCard\n'
        'Purchase a Car',
    initiallyNull: true,
  );
}

class _UseCase extends StatefulWidget {
  const _UseCase({
    required this.text,
    required this.onlyNames,
  });

  final String text;
  final Set<String> onlyNames;

  @override
  State<_UseCase> createState() => _UseCaseState();
}

class _UseCaseState extends State<_UseCase> {
  @override
  void didUpdateWidget(covariant _UseCase oldWidget) {
    super.didUpdateWidget(oldWidget);
    final unionLength = widget.onlyNames.union(oldWidget.onlyNames).length;

    final onlyChanged =
        !(widget.onlyNames.length == oldWidget.onlyNames.length &&
            unionLength == widget.onlyNames.length);

    if (onlyChanged) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.onlyNames.isEmpty ||
            (widget.onlyNames.length == 1 && widget.onlyNames.first.isEmpty)) {
          updateDebugWerkbankFilter(DebugWerkbankFilter.disabled);
          return;
        }
        updateDebugWerkbankFilter(
          DebugWerkbankFilter.displayOnly(widget.onlyNames),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '👋,  ${widget.text}',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: debugWerkbankFilter,
            builder: (context, value, child) {
              return Text('DebugWerkbankFilter: ${value.name}');
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final val in DebugWerkbankFilter.mostValues)
                WChip(
                  onPressed: () {
                    updateDebugWerkbankFilter(val);
                  },
                  label: Text(val.name),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
