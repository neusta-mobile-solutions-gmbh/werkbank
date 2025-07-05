import 'package:example_werkbank/src/example_app/components/animated_fidget_spinner.dart';
import 'package:example_werkbank/src/example_app/components/fidget_spinner_simulation.dart';
import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankComponent get fidgetSpinnerComponent => WerkbankComponent(
  name: 'Fidget Spinner',
  useCases: [
    WerkbankUseCase(
      name: 'AnimatedFidgetSpinner',
      builder: _animatedUseCase,
    ),
    WerkbankUseCase(
      name: 'FidgetSpinnerSimulation',
      builder: _simulationUseCase,
    ),
  ],
);

WidgetBuilder _animatedUseCase(UseCaseComposer c) {
  c.description(
    'An animated fidget spinner.\n'
    '## Notable Werkbank Features:\n'
    '- The fidget spinner field uses a special **animation controller knob** '
    'that allows you to pass an `AnimationController` to your widget and '
    '**control it in the UI**.\n',
  );
  c.overview.minimumSize(width: 256, height: 256);

  final sizeKnob = c.knobs.intSlider(
    'Size',
    initialValue: 256,
    max: 256,
    valueFormatter: (v) => '$v px',
  );
  final turnsKnob = c.knobs.animationController(
    'Turns',
    initialDuration: Durations.extralong1,
  );

  return (context) {
    return AnimatedFidgetSpinner(
      size: sizeKnob.value.toDouble(),
      color: Theme.of(context).colorScheme.primary,
      turns: turnsKnob.value,
    );
  };
}

WidgetBuilder _simulationUseCase(UseCaseComposer c) {
  c.description(
    'A simulation of a fidget spinner.\n'
    '## Notable Werkbank Features:\n'
    '- The **thumbnail** in the overview for this use case **looks '
    'different** from how it does in the main view. '
    'This shows that widgets can be configured depending on if they '
    'are shown in the overview or even changed completely for '
    'a **custom thumbnail**.\n'
    '- The numbers of **slider knobs** can have arbitrary **formatting** '
    'like for example units.',
  );
  c.overview.minimumSize(width: 256, height: 256);

  final sizeKnob = c.knobs.intSlider(
    'Size',
    initialValue: 256,
    max: 256,
    valueFormatter: (v) => '$v px',
  );
  final targetTurnsKnob = c.knobs.doubleSlider(
    'Target Angle',
    initialValue: 2.13,
    max: 5,
    valueFormatter: (v) => '${(v * 360).toInt()}°',
  );
  final massKnob = c.knobs.doubleSlider(
    'Mass',
    initialValue: 1.0,
    min: 0.1,
    max: 10.0,
    valueFormatter: (v) => '${v.toStringAsFixed(2)} kg',
  );
  final stiffnessKnob = c.knobs.doubleSlider(
    'Stiffness',
    initialValue: 20.0,
    min: 1.0,
    max: 100.0,
    valueFormatter: (v) => '${v.toStringAsFixed(1)} N/m',
  );
  final dampingRatioKnob = c.knobs.doubleSlider(
    'Damping Ratio',
    initialValue: 1.0,
    min: 0.0,
    max: 2.0,
  );

  return (context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        FidgetSpinnerSimulation(
          size: sizeKnob.value.toDouble(),
          color: Theme.of(context).colorScheme.primary,
          targetTurns: targetTurnsKnob.value,
          mass: massKnob.value,
          stiffness: stiffnessKnob.value,
          dampingRatio: dampingRatioKnob.value,
        ),
        // Add "Sim" label in the overview to
        // tell it apart from the animated spinner.
        if (UseCase.isInOverviewOf(context))
          Positioned(
            top: 0,
            left: 0,
            child: Transform.rotate(
              angle: -0.3,
              child: Text(
                'Sim',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  };
}
