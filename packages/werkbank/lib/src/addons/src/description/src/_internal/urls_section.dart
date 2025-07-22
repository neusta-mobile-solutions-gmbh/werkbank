import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlsSection extends StatelessWidget {
  const UrlsSection({
    required this.urls,
    super.key,
  });

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final url in urls) _Url(url: url),
      ],
    );
  }
}

class _Url extends StatelessWidget {
  const _Url({
    required this.url,
  });

  final String url;

  Widget? _guessIcon(BuildContext context, Uri uri) {
    // NOTE(lwiedekamp): If someone needs this in the future,
    // this logic can be improved
    if (uri.host.contains('figma')) {
      return const Icon(WerkbankIcons.figmaLogo);
    }
    if (uri.host.contains('git')) {
      return const Icon(WerkbankIcons.githubLogo);
    }
    if (uri.host.contains('apple')) {
      return const Icon(WerkbankIcons.appleLogo);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // c.urls(...); already checks for valid URLs
    final uri = Uri.parse(url);

    return WChip(
      onPressed: () => _launchUrl(uri),
      leading: _guessIcon(context, uri),
      label: Text(
        uri.host.withoutPrefix('www.'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(WerkbankIcons.arrowSquareOut),
    );
  }
}

Future<void> _launchUrl(Uri uri) async {
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}

extension on String {
  String withoutPrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length);
    }
    return this;
  }
}
