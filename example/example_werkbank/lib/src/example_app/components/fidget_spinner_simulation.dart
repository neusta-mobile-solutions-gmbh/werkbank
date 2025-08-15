import 'dart:async';

import 'package:example_werkbank/src/example_app/components/animated_fidget_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class FidgetSpinnerSimulation extends StatefulWidget {
  const FidgetSpinnerSimulation({
    super.key,
    this.size,
    this.color,
    required this.mass,
    required this.stiffness,
    required this.dampingRatio,
    required this.targetTurns,
  });

  final double? size;
  final Color? color;
  final double mass;
  final double stiffness;
  final double dampingRatio;
  final double targetTurns;

  @override
  State<FidgetSpinnerSimulation> createState() =>
      _FidgetSpinnerSimulationState();
}

class _FidgetSpinnerSimulationState extends State<FidgetSpinnerSimulation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinnerAnimationController;

  @override
  void initState() {
    super.initState();
    _spinnerAnimationController = AnimationController(
      vsync: this,
      value: widget.targetTurns,
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );
  }

  void _updateSimulation() {
    unawaited(
      _spinnerAnimationController.animateWith(
        SpringSimulation(
          SpringDescription.withDampingRatio(
            mass: widget.mass,
            stiffness: widget.stiffness,
            ratio: widget.dampingRatio,
          ),
          _spinnerAnimationController.value,
          widget.targetTurns,
          _spinnerAnimationController.velocity,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(
    covariant FidgetSpinnerSimulation oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    _updateSimulation();
  }

  @override
  void dispose() {
    _spinnerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedFidgetSpinner(
      size: widget.size,
      color: widget.color,
      turns: _spinnerAnimationController,
    );
  }
}
