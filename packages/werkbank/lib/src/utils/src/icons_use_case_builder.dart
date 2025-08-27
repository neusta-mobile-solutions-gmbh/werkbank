import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/addons.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

UseCaseBuilder iconsUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, IconData> Function(BuildContext context) icons,
  Color? surfaceColor,
  Color? onSurfaceColor,
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
          surfaceColor: surfaceColor,
          onSurfaceColor: onSurfaceColor,
        ),
      );
    };
  };
}

class _IconsShowCase extends StatelessWidget {
  const _IconsShowCase({
    required this.icons,
    required this.size,
    this.surfaceColor,
    this.onSurfaceColor,
  });

  final Map<String, IconData> icons;
  final double size;
  final Color? surfaceColor;
  final Color? onSurfaceColor;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final surfaceColor =
        this.surfaceColor ??
        (brightness == Brightness.dark ? Colors.black : Colors.white);
    final onSurfaceColor =
        this.onSurfaceColor ??
        (brightness == Brightness.dark ? Colors.white : Colors.black);
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
                    border: Border.all(color: onSurfaceColor),
                  ),
                  child: IntrinsicWidth(
                    child: ColoredBox(
                      color: surfaceColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              icon.value,
                              size: size,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            child: Text(
                              icon.key,
                              style: TextStyle(color: onSurfaceColor),
                            ),
                          ),
                        ],
                      ),
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
