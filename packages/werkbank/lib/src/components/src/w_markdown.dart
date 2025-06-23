import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:werkbank/src/werkbank_internal.dart';

typedef WMarkdownTapLinkCallback =
    void Function(
      String text,
      String? href,
      String title,
    );

/// {@category Werkbank Components}
class WMarkdown extends StatelessWidget {
  const WMarkdown({
    required this.data,
    this.onTapLink,
    super.key,
  });

  final String data;
  final WMarkdownTapLinkCallback? onTapLink;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;

    final textStyle = textTheme.defaultText.copyWith(
      color: colorScheme.fieldContent,
    );

    return MarkdownBody(
      data: data,
      // TODO(lwiedekamp): To match the
      // design system of Werkbank,
      // this mapping should
      // be continued and completed.
      styleSheet:
          MarkdownStyleSheet.fromTheme(
            Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: colorScheme.fieldContent,
                displayColor: colorScheme.fieldContent,
              ),
            ),
          ).copyWith(
            p: textStyle,
            code: textTheme.interaction.copyWith(
              color: colorScheme.fieldContent,
            ),
            codeblockDecoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      onTapLink: onTapLink,
    );
  }
}
