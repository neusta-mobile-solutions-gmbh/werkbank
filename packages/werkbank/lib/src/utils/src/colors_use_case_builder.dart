import 'package:flutter/material.dart';

UseCaseBuilder colorsUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, Color> Function(BuildContext context) colors,
}) {
  return (c) {
    final sizeKnob = c.knobs.doubleSlider(
      'Size',
      min: 50,
      max: 300,
      initialValue: 100,
    );
    c
      ..tags(['colors', 'theme'])
      ..description(
        'A default UseCase of Werkbank to display '
        'all colors of a theme.',
      );
    builder(c);
    return (context) {
      return SingleChildScrollView(
        child: _ColorsShowCase(
          colors: colors(context),
          size: sizeKnob.value,
        ),
      );
    };
  };
}

class _ColorsShowCase extends StatelessWidget {
  const _ColorsShowCase({
    required this.colors,
    required this.size,
  });

  final Map<String, Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 32,
        runSpacing: 32,
        children: [
          for (final color in colors.entries)
            Builder(
              builder: (context) {
                final colorHex = color.value
                    .toARGB32()
                    .toRadixString(16)
                    .padLeft(8, '0');
                final colorHexText = '0x$colorHex';
                return Container(
                  constraints: BoxConstraints(minWidth: size),
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: color.value,
                          height: size,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(color.key),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(colorHexText),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
