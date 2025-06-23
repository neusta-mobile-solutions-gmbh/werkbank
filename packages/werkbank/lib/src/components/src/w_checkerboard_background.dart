import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WCheckerboardBackground extends StatelessWidget {
  const WCheckerboardBackground({
    super.key,
    this.squareSize = 12,
    this.color1 = const Color(0xff909090),
    this.color2 = const Color(0xff707070),
  });

  final double squareSize;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color1,
      child: Image.asset(
        'assets/components/background/checkerboard.png',
        package: 'werkbank',
        repeat: ImageRepeat.repeat,
        filterQuality: FilterQuality.none,
        scale: 1 / squareSize,
        color: color2,
        colorBlendMode: BlendMode.srcATop,
      ),
    );
  }
}
