import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/addons.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

UseCaseBuilder colorsUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, Color> Function(BuildContext context) colors,
  double initialSize = 100,
  bool addTagsAndDescription = true,
  Color? surfaceColor,
  Color? onSurfaceColor,
}) {
  return (c) {
    final sizeKnob = c.isAddonActive(KnobsAddon.addonId)
        ? c.knobs.doubleSlider(
            'Size',
            min: 50,
            max: 300,
            initialValue: initialSize,
          )
        : null;
    if (addTagsAndDescription && c.isAddonActive(DescriptionAddon.addonId)) {
      c
        ..tags(['theme'])
        ..description(
          'A use case that displays color of the theme.',
        );
    }
    if (c.isAddonActive(BackgroundAddon.addonId)) {
      c.background.colorBuilder((context) {
        late final brightness = UseCase.themeBrightnessOf(context);
        return surfaceColor ??
            switch (brightness) {
              Brightness.dark => Colors.black,
              Brightness.light => Colors.white,
            };
      });
    }
    builder(c);
    return (context) {
      late final brightness = UseCase.themeBrightnessOf(context);
      final effectiveSurfaceColor =
          surfaceColor ??
          switch (brightness) {
            Brightness.dark => Colors.black,
            Brightness.light => Colors.white,
          };
      final effectiveOnSurfaceColor =
          onSurfaceColor ??
          switch (brightness) {
            Brightness.dark => Colors.white,
            Brightness.light => Colors.black,
          };
      return _ColorsUseCase(
        colors: colors(context),
        size: sizeKnob?.value ?? initialSize,
        surfaceColor: effectiveSurfaceColor,
        onSurfaceColor: effectiveOnSurfaceColor,
      );
    };
  };
}

class _ColorsUseCase extends StatelessWidget {
  const _ColorsUseCase({
    required this.colors,
    required this.size,
    this.surfaceColor,
    this.onSurfaceColor,
  });

  final Map<String, Color> colors;
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final color in colors.entries)
            Builder(
              builder: (context) {
                final colorHex = color.value
                    .toARGB32()
                    .toRadixString(16)
                    .padLeft(8, '0');
                final colorHexText = '0x$colorHex';
                return DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: onSurfaceColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: size),
                      child: IntrinsicWidth(
                        child: ColoredBox(
                          color: surfaceColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DecoratedBox(
                                position: DecorationPosition.foreground,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: onSurfaceColor),
                                  ),
                                ),
                                child: SizedBox(
                                  height: size,
                                  child: ColoredBox(
                                    color: color.value,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      color.key,
                                      style: TextStyle(color: onSurfaceColor),
                                    ),
                                    Text(
                                      colorHexText,
                                      style: TextStyle(color: onSurfaceColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
