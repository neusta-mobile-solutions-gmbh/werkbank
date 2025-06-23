import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder hotReloadEffectUseCase(UseCaseComposer c) {
  c
    ..description('This effect is visible when the app is doing a hot reload.')
    ..tags([Tags.shader, Tags.hotReload, Tags.feature, Tags.addon, '#10099'])
    ..overview.minimumSize(width: 450);

  final weight1Knob = c.knobs.doubleSlider(
    'TweenSequence 1',
    initialValue: 5,
    min: 1,
    max: 20,
  );

  final weight2Knob = c.knobs.doubleSlider(
    'TweenSequence 2',
    initialValue: 30,
    min: 2,
    max: 50,
  );

  final animationControllerKnob = c.knobs.animationController(
    'Animation Controller',
    initialValue: 1,
    initialDuration: Durations.extralong4,
  );

  final curveKnob = c.knobs.curve(
    'Curve',
    initialValue: Curves.easeInQuad,
  );

  return (context) {
    final animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1, end: 1),
        weight: weight1Knob.value,
      ),
      TweenSequenceItem<double>(
        tween: CurveTween(
          curve: curveKnob.value,
        ).chain(Tween<double>(begin: 1, end: 0)),
        weight: weight2Knob.value,
      ),
    ]).animate(animationControllerKnob.value);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Text('Value: ${animation.value.toStringAsFixed(2)}');
          },
        ),
        WHotReloadEffect(
          animation: animation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red,
                  Colors.blue,
                ],
              ),
            ),
            padding: const EdgeInsets.all(32),
            child: const FlutterLogo(size: 300),
          ),
        ),
      ],
    );
  };
}
