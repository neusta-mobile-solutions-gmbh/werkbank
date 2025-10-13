import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/addons.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/use_case_metadata/use_case_metadata.dart';

UseCaseBuilder iconsUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, IconData> Function(BuildContext context) icons,
  double initialSize = 48,
  bool addTagsAndDescription = true,
  Color? surfaceColor,
  Color? onSurfaceColor,
}) {
  return (c) {
    final sizeKnob = c.isAddonActive(KnobsAddon.addonId)
        ? c.knobs.doubleSlider(
            'Size',
            min: 12,
            max: 200,
            initialValue: initialSize,
          )
        : null;
    if (addTagsAndDescription && c.isAddonActive(DescriptionAddon.addonId)) {
      c
        ..tags(['theme'])
        ..description('A use case that displays icons with their names.');
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
    c.overview
      ..withoutPadding()
      ..minimumSize(width: 500);
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
      return _IconsUseCase(
        icons: icons(context),
        size: sizeKnob?.value ?? initialSize,
        surfaceColor: effectiveSurfaceColor,
        onSurfaceColor: effectiveOnSurfaceColor,
      );
    };
  };
}

class _IconsUseCase extends StatelessWidget {
  const _IconsUseCase({
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
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final icon in icons.entries)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: onSurfaceColor),
                  ),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: onSurfaceColor),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              icon.value,
                              size: size,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            icon.key,
                            style: TextStyle(color: onSurfaceColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
