import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/addons.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/use_case_metadata/use_case_metadata.dart';

UseCaseBuilder textStylesUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, TextStyle> Function(BuildContext context) styles,
  String? initialText,
  bool textInitiallyNull = true,
  bool addTagsAndDescription = true,
  Color? surfaceColor,
  Color? onSurfaceColor,
}) {
  return (c) {
    final textKnob = c.isAddonActive(KnobsAddon.addonId)
        ? c.knobs.nullable.stringMultiLine(
            'Text',
            initiallyNull: textInitiallyNull,
            initialValue:
                initialText ?? 'Sphinx of black quartz, judge my vow.',
          )
        : null;
    if (addTagsAndDescription && c.isAddonActive(DescriptionAddon.addonId)) {
      c
        ..tags(['theme'])
        ..description(
          'A use case that displays text styles of the theme.',
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
      return _TextStylesUseCase(
        styles: styles(context),
        text: textKnob != null ? textKnob.value : initialText,
        surfaceColor: effectiveSurfaceColor,
        onSurfaceColor: effectiveOnSurfaceColor,
      );
    };
  };
}

class _TextStylesUseCase extends StatelessWidget {
  const _TextStylesUseCase({
    required this.styles,
    required this.text,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  final Map<String, TextStyle> styles;
  final String? text;
  final Color surfaceColor;
  final Color onSurfaceColor;

  @override
  Widget build(BuildContext context) {
    final styleEntries = styles.entries.toList();
    final fontWeightTexts = [
      for (final entry in styleEntries)
        entry.value.fontWeight?.displayName ?? 'null',
    ];
    final fontSizeTexts = [
      for (final entry in styleEntries)
        entry.value.fontSize?.toStringAsFixed(1) ?? 'null',
    ];
    final heightTexts = [
      for (final entry in styleEntries)
        entry.value.height?.toStringAsFixed(1) ?? 'null',
    ];
    final letterSpacingTexts = [
      for (final entry in styleEntries)
        entry.value.letterSpacing?.toStringAsFixed(2) ?? 'null',
    ];
    final allFontWeightTexts = fontWeightTexts.toSet();
    final allFontSizeTexts = fontSizeTexts.toSet();
    final allHeightTexts = heightTexts.toSet();
    final allLetterSpacingTexts = letterSpacingTexts.toSet();
    return ListView.separated(
      itemCount: styleEntries.length,
      padding: const EdgeInsets.all(32),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => Builder(
        builder: (context) {
          final styleEntry = styleEntries[index];
          final style = styleEntry.value;
          return _TextStyleDisplayRowItem(
            fontWeightLabel: _WidthFittingText(
              text: fontWeightTexts[index],
              widthTexts: allFontWeightTexts,
            ),
            fontSizeLabel: _WidthFittingText(
              text: fontSizeTexts[index],
              widthTexts: allFontSizeTexts,
            ),
            heightLabel: _WidthFittingText(
              text: heightTexts[index],
              widthTexts: allHeightTexts,
            ),
            letterSpacingLabel: _WidthFittingText(
              text: letterSpacingTexts[index],
              widthTexts: allLetterSpacingTexts,
            ),
            label: styleEntry.key,
            textStyle: style,
            text: text,
            surfaceColor: surfaceColor,
            onSurfaceColor: onSurfaceColor,
          );
        },
      ),
    );
  }
}

class _TextStyleDisplayRowItem extends StatelessWidget {
  const _TextStyleDisplayRowItem({
    required this.fontWeightLabel,
    required this.fontSizeLabel,
    required this.heightLabel,
    required this.letterSpacingLabel,
    required this.label,
    required this.textStyle,
    required this.surfaceColor,
    required this.onSurfaceColor,
    this.text,
  });

  final Widget fontWeightLabel;
  final Widget fontSizeLabel;
  final Widget heightLabel;
  final Widget letterSpacingLabel;
  final String label;
  final TextStyle textStyle;
  final String? text;
  final Color surfaceColor;
  final Color onSurfaceColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: onSurfaceColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: text != null
                  ? Border(bottom: BorderSide(color: onSurfaceColor))
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                spacing: 16,
                children: [
                  _TextStyleDisplayItem(
                    label: fontWeightLabel,
                    icon: const Icon(Icons.font_download),
                    tooltipMessage: 'Font Weight',
                    surfaceColor: surfaceColor,
                    onSurfaceColor: onSurfaceColor,
                  ),
                  _TextStyleDisplayItem(
                    label: fontSizeLabel,
                    icon: const Icon(Icons.text_fields),
                    tooltipMessage: 'Font Size',
                    surfaceColor: surfaceColor,
                    onSurfaceColor: onSurfaceColor,
                  ),
                  _TextStyleDisplayItem(
                    label: heightLabel,
                    icon: const Icon(Icons.height),
                    tooltipMessage: 'Height',
                    surfaceColor: surfaceColor,
                    onSurfaceColor: onSurfaceColor,
                  ),
                  _TextStyleDisplayItem(
                    label: letterSpacingLabel,
                    icon: const Icon(Icons.space_bar),
                    tooltipMessage: 'Letter Spacing',
                    surfaceColor: surfaceColor,
                    onSurfaceColor: onSurfaceColor,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(text!, style: textStyle),
            ),
        ],
      ),
    );
  }
}

class _TextStyleDisplayItem extends StatelessWidget {
  const _TextStyleDisplayItem({
    required this.label,
    required this.icon,
    required this.tooltipMessage,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  final Widget label;
  final Widget icon;
  final String tooltipMessage;
  final Color surfaceColor;
  final Color onSurfaceColor;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: onSurfaceColor,
            ),
          ),
          textStyle: TextStyle(
            color: onSurfaceColor,
          ),
        ),
      ),
      child: Tooltip(
        message: tooltipMessage,
        waitDuration: Durations.long4,
        child: Row(
          spacing: 8,
          children: [
            icon,
            DefaultTextStyle.merge(
              style: TextStyle(color: onSurfaceColor),
              child: label,
            ),
          ],
        ),
      ),
    );
  }
}

class _WidthFittingText extends StatelessWidget {
  const _WidthFittingText({
    required this.text,
    required this.widthTexts,
  });

  final String text;
  final Set<String> widthTexts;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        for (final widthText in widthTexts)
          if (widthText != text)
            Visibility(
              visible: false,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Text(
                widthText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ],
    );
  }
}

extension on FontWeight {
  String get displayName {
    return switch (this) {
      FontWeight.w100 => 'Thin',
      FontWeight.w200 => 'Extra Light',
      FontWeight.w300 => 'Light',
      FontWeight.w400 => 'Normal',
      FontWeight.w500 => 'Medium',
      FontWeight.w600 => 'Semi Bold',
      FontWeight.w700 => 'Bold',
      FontWeight.w800 => 'Extra Bold',
      FontWeight.w900 => 'Black',
      _ => throw AssertionError(),
    };
  }
}
