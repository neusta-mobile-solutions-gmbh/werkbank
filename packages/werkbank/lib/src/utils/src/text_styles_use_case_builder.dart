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
            final styleEntry = styles.entries.elementAt(index);
            final style = styleEntry.value;
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
                      label: styleEntry.key,
                      textStyle: style,
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
    required this.textStyle,
    required this.color,
    this.text,
    super.key,
  });

  final String label;
  final TextStyle textStyle;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 16,
            children: [
              TextStyleDisplayItem(
                label: Text(textStyle.fontWeight?.displayName ?? 'null'),
                icon: const Icon(Icons.font_download),
                color: color,
              ),
              TextStyleDisplayItem(
                label: Text(textStyle.fontSize?.toStringAsFixed(1) ?? 'null'),
                icon: const Icon(Icons.text_fields),
                color: color,
              ),
              TextStyleDisplayItem(
                label: Text(textStyle.height?.toStringAsFixed(1) ?? 'null'),
                icon: const Icon(Icons.height),
                color: color,
              ),
              TextStyleDisplayItem(
                label: Text(
                  textStyle.letterSpacing?.toStringAsFixed(1) ?? 'null',
                ),
                icon: const Icon(Icons.space_bar),
                color: color,
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
        if (text != null) ...[
          WDivider.horizontal(
            thickness: 1,
            color: color,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(text!, style: textStyle),
          ),
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

  final Widget label;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        icon,
        label,
      ],
    );
  }
}

extension FontWeightExtension on FontWeight {
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
