import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wDelayedRevealUseCase(UseCaseComposer c) {
  c.overview.minimumSize(width: 300, height: 300);
  c.description(
    'A widget to delay the reveal of its child.',
  );

  final minDelay = c.knobs.millis(
    'Min Delay',
    initialValue: const Duration(milliseconds: 100),
  );

  final maxDelay = c.knobs.millis(
    'Max Delay',
    initialValue: const Duration(milliseconds: 300),
  );

  final delayCurve = c.knobs.curve(
    'Delay Curve',
    initialValue: Curves.easeIn,
  );

  final revealDuration = c.knobs.millis(
    'Reveal Duration',
    initialValue: const Duration(milliseconds: 400),
  );

  return (context) {
    const count = 100;
    const size = 16.0;
    const columns = 10;
    const spacing = 8.0;
    return SizedBox(
      key: ValueKey(
        (
          minDelay.value,
          maxDelay.value,
          delayCurve.value,
          revealDuration.value,
        ),
      ),
      width: size * columns + spacing * (columns - 1),
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (var i = 0; i < count; i++)
            SizedBox(
              width: size,
              height: size,
              child: WDelayedReveal.randomDelay(
                minDelay: minDelay.value,
                maxDelay: maxDelay.value,
                delayCurve: delayCurve.value,
                revealDuration: revealDuration.value,
                placeholder: const SizedBox.expand(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
        ],
      ),
    );
  };
}
