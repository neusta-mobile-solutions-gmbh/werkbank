import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/text_span_semantics_data_field.dart';

class LinkSemanticsDataField extends StatelessWidget {
  const LinkSemanticsDataField({
    super.key,
    required this.name,
    required this.uri,
  });

  final String name;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return TextSpanSemanticsDataField(
      name: name,
      value: TextSpan(
        text: uri.toString(),
        style: const TextStyle(decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            unawaited(launchUrl(uri));
          },
      ),
    );
  }
}
