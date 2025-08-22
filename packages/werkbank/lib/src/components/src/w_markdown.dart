import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WMarkdown extends StatelessWidget {
  const WMarkdown({
    required this.data,
    super.key,
  });

  final String data;

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
      onTapLink: (text, href, title) async {
        if (href == null) return;
        final uri = Uri.tryParse(href);
        if (uri == null) return;
        await launchUrl(uri);
      },
    );
  }
}
