import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class ConstraintsVisualizer extends StatelessWidget {
  const ConstraintsVisualizer({
    required this.expandHorizontally,
    required this.expandVertically,
    super.key,
  });

  final bool expandHorizontally;
  final bool expandVertically;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidthString = constraints.minWidth.toStringAsFixed(0);
        final maxWidthString = constraints.maxWidth.toStringAsFixed(0);
        final minHeightString = constraints.minHeight.toStringAsFixed(0);
        final maxHeightString = constraints.maxHeight.toStringAsFixed(0);

        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.werkbankColorScheme.fieldContent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: expandHorizontally ? 1 : 0,
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: expandVertically ? 1 : 0,
                          child: WTextArea(text: 'Min Width: $minWidthString'),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          flex: expandVertically ? 1 : 0,
                          child: WTextArea(
                            text: 'Min Height: $minHeightString',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: expandHorizontally ? 1 : 0,
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: expandVertically ? 1 : 0,
                          child: WTextArea(text: 'Max Width: $maxWidthString'),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          flex: expandVertically ? 1 : 0,
                          child: WTextArea(
                            text: 'Max Height: $maxHeightString',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
