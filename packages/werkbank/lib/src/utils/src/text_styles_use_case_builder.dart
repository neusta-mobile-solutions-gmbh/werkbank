import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

UseCaseBuilder textStylesUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, TextStyle> Function(BuildContext context) styles,
  Color? surfaceColor,
  Color? onSurfaceColor,
  String? initialText,
  bool textInitiallyNull = true,
}) {
  return (c) {
    final textKnob = c.knobs.nullable.stringMultiLine(
      'Text',
      initiallyNull: textInitiallyNull,
      initialValue: initialText ?? 'Sphinx of black quartz, judge my vow.',
    );
    c
      ..tags(['font', 'textStyle', 'theme'])
      ..description(
        'A default UseCase of Werkbank to display '
        'all textStyles of a theme.',
      );
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
        text: textKnob.value,
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
    return ListView.separated(
      itemCount: styleEntries.length,
      padding: const EdgeInsets.all(32),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => Builder(
        builder: (context) {
          final styleEntry = styleEntries[index];
          final style = styleEntry.value;
          return _TextStyleDisplayRowItem(
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
    required this.label,
    required this.textStyle,
    required this.surfaceColor,
    required this.onSurfaceColor,
    this.text,
    super.key,
  });

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
                    label: Text(textStyle.fontWeight?.displayName ?? 'null'),
                    icon: const Icon(Icons.font_download),
                    onSurfaceColor: onSurfaceColor,
                  ),
                  _TextStyleDisplayItem(
                    label: Text(
                      textStyle.fontSize?.toStringAsFixed(1) ?? 'null',
                    ),
                    icon: const Icon(Icons.text_fields),
                    onSurfaceColor: onSurfaceColor,
                  ),
                  _TextStyleDisplayItem(
                    label: Text(textStyle.height?.toStringAsFixed(1) ?? 'null'),
                    icon: const Icon(Icons.height),
                    onSurfaceColor: onSurfaceColor,
                  ),
                  _TextStyleDisplayItem(
                    label: Text(
                      textStyle.letterSpacing?.toStringAsFixed(1) ?? 'null',
                    ),
                    icon: const Icon(Icons.space_bar),
                    onSurfaceColor: onSurfaceColor,
                    // TODO: run werkbank icon_font_generator
                    // icon: const Icon(WerkbankIcons.horizontal),
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
    required this.onSurfaceColor,
  });

  final Widget label;
  final Widget icon;
  final Color onSurfaceColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        icon,
        DefaultTextStyle.merge(
          style: TextStyle(color: onSurfaceColor),
          child: label,
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
