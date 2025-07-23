import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    required this.data,
    this.hint,
    super.key,
  });

  final String data;
  final Widget? hint;

  @override
  Widget build(BuildContext context) {
    final widget = WFieldBox(
      child: WMarkdown(
        data: data,
        onTapLink: (text, href, title) async {
          if (href == null) return;
          final uri = Uri.tryParse(href);
          if (uri == null) return;
          await _launchUrl(uri);
        },
      ),
    );

    if (hint == null) return widget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle.merge(
          style: context.werkbankTextTheme.textSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          child: hint!,
        ),
        const SizedBox(height: 4),
        widget,
      ],
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
