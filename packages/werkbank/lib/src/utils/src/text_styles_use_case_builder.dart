import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/addons.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

UseCaseBuilder textStylesUseCaseBuilder({
  required void Function(UseCaseComposer c) builder,
  required Map<String, TextStyle> Function(BuildContext context) styles,
  String? initialValue,
}) {
  return (c) {
    final textKnob = c.knobs.string(
      'Text',
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
  final String text;

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    style.key,
                    style: style.value,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  Text(text, style: style.value),
                  const SizedBox(height: 16),
                  const WDivider.horizontal(
                    // To avoid using a theme-color outside of
                    // the werkbank-theme-scoped context
                    color: Colors.black,
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
