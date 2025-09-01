import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

UseCaseBuilder textStylesUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, TextStyle> Function(BuildContext context) styles,
  String? initialValue,
}) {
  return (c) {
    final textKnob = c.knobs.nullable.string(
      'Text',
      initiallyNull: true,
      initialValue:
          initialValue ??
          'Lorem ipsum dolor sit amet consectetur adipiscing elit',
    );
    c
      ..tags(['font', 'textStyle', 'theme'])
      ..description(
        'A default UseCase of Werkbank to display '
        'all textStyles of a theme.',
      );
    builder(c);
    return (context) {
      return _TextStylesShowCase(
        styles: styles(context),
        text: textKnob.value,
      );
    };
  };
}

class _TextStylesShowCase extends StatelessWidget {
  const _TextStylesShowCase({
    required this.styles,
    required this.text,
  });

  final Map<String, TextStyle> styles;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final onSurfaceColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: ListView.builder(
        itemCount: styles.length,
        itemBuilder: (context, index) => Builder(
          builder: (context) {
            final style = styles.entries.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: onSurfaceColor,
                      ),
                    ),
                    child: TextStyleDisplayRowItem(
                      label: style.key,
                      fontSize: style.value.fontSize ?? 14,
                      fontHeight:
                          ((style.value.fontSize ?? 14) *
                                  (style.value.height ?? 1.2))
                              .ceil(),
                      fontWeight:
                          style.value.fontWeight?.displayName ??
                          'FontWeight.w400',
                      letterSpacing: style.value.letterSpacing ?? 0,
                      textStyle: style.value,
                      text: text,
                      color: onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TextStyleDisplayRowItem extends StatelessWidget {
  const TextStyleDisplayRowItem({
    required this.label,
    required this.fontSize,
    required this.fontHeight,
    required this.fontWeight,
    required this.letterSpacing,
    required this.textStyle,
    required this.color,
    this.text,
    super.key,
  });

  final String label;
  final double fontSize;
  final int fontHeight;
  final String fontWeight;
  final double letterSpacing;
  final TextStyle textStyle;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            TextStyleDisplayItem(
              label: fontWeight,
              icon: const Icon(Icons.font_download),
              color: color,
            ),
            const SizedBox(width: 16),
            TextStyleDisplayItem(
              label: fontSize.toInt().toString(),
              icon: const Icon(Icons.text_fields),
              color: color,
            ),
            const SizedBox(width: 16),
            TextStyleDisplayItem(
              label: fontHeight.toString(),
              icon: const Icon(Icons.height),
              color: color,
            ),
            const SizedBox(width: 16),
            TextStyleDisplayItem(
              label: letterSpacing.toString(),
              icon: const Icon(Icons.space_bar),
              color: color,
              // TODO(lzuttermeister): run werkbank icon_font_generator
              // icon: const Icon(WerkbankIcons.horizontal),
            ),
            const SizedBox(width: 16),
            Text(label),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        if (text != null) ...[
          WDivider.horizontal(
            thickness: 1,
            color: color,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(text!, style: textStyle),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class TextStyleDisplayItem extends StatelessWidget {
  const TextStyleDisplayItem({
    required this.label,
    required this.icon,
    required this.color,
    super.key,
  });

  final String label;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
