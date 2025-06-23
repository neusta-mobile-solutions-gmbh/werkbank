import 'package:flutter/material.dart';

class ConstraintsLayout extends StatelessWidget {
  const ConstraintsLayout({
    super.key,
    required this.rulerCorner,
    required this.hRuler,
    required this.vRuler,
    required this.child,
  });

  static const _rulerThickness = 20.0;

  final Widget rulerCorner;
  final Widget hRuler;
  final Widget vRuler;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: _rulerThickness,
            left: _rulerThickness,
          ),
          child: child,
        ),
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            width: _rulerThickness,
            height: _rulerThickness,
            child: rulerCorner,
          ),
        ),
        Positioned(
          top: 0,
          left: _rulerThickness,
          right: 0,
          child: SizedBox(
            height: _rulerThickness,
            child: hRuler,
          ),
        ),
        Positioned(
          top: _rulerThickness,
          left: 0,
          bottom: 0,
          child: SizedBox(
            width: _rulerThickness,
            child: vRuler,
          ),
        ),
      ],
    );
  }
}
