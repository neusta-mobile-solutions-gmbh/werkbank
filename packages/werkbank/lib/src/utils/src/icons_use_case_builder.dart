import 'package:flutter/material.dart';

UseCaseBuilder iconsUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, IconData> Function(BuildContext context) icons,
}) {
  return (c) {
    final sizeKnob = c.knobs.doubleSlider(
      'Size',
      min: 12,
      max: 200,
      initialValue: 48,
    );
    c
      ..tags(['colors', 'theme'])
      ..description(
        'A default UseCase of Werkbank to display '
        'all icons of a theme.',
      );
    builder(c);
    return (context) {
      return SingleChildScrollView(
        child: _IconsShowCase(
          icons: icons(context),
          size: sizeKnob.value,
        ),
      );
    };
  };
}

class _IconsShowCase extends StatelessWidget {
  const _IconsShowCase({
    required this.icons,
    required this.size,
  });

  final Map<String, IconData> icons;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 32,
        runSpacing: 32,
        children: [
          for (final icon in icons.entries)
            Builder(
              builder: (context) {
                return Container(
                  constraints: BoxConstraints(minWidth: size),
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon.value,
                          size: size,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          child: Text(icon.key),
                        ),
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
