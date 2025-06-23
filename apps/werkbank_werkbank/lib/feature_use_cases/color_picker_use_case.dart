import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder colorPickerUseCase(UseCaseComposer c) {
  final sizeKnob = c.knobs.doubleSlider(
    'Square Size',
    initialValue: 10,
    min: 0.5,
    max: 150,
  );

  return (context) {
    return SizedBox(
      width: 5 * sizeKnob.value,
      height: 10 * sizeKnob.value,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemBuilder: (context, index) {
          return SizedBox(
            height: sizeKnob.value,
            width: sizeKnob.value,
            child: const _ColorBox(),
          );
        },
      ),
    );
  };
}

class _ColorBox extends StatefulWidget {
  const _ColorBox();

  @override
  State<_ColorBox> createState() => _ColorBoxState();
}

class _ColorBoxState extends State<_ColorBox> {
  late final Color _color;

  @override
  void initState() {
    super.initState();
    final random = Random();

    final alpha = random.nextBool() ? random.nextInt(256) : 255;
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);

    _color = Color.fromARGB(alpha, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    final alpha = _color.a.toStringAsFixed(4);
    final red = _color.r.toStringAsFixed(4);
    final green = _color.g.toStringAsFixed(4);
    final blue = _color.b.toStringAsFixed(4);
    return ColoredBox(
      color: _color,
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'A: $alpha\nR: $red\nG: $green\nB: $blue '
            '\nHex: ${_color.toARGB32().toRadixString(16).padLeft(8, '0')}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
