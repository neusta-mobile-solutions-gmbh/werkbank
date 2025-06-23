import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Werkbank Components}
class WPathDisplay extends StatelessWidget {
  const WPathDisplay({
    super.key,
    required this.nameSegments,
  });

  final List<String> nameSegments;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WPathText(
          nameSegments: nameSegments
              .take(max(nameSegments.length - 1, 0))
              .toList(),
          isRelative: false,
          isDirectory: nameSegments.length > 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.textSmall.copyWith(
            color: colorScheme.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          nameSegments.isNotEmpty ? nameSegments.last : '',
          overflow: TextOverflow.ellipsis,
          style: textTheme.defaultText.copyWith(
            color: colorScheme.text,
          ),
        ),
      ],
    );
  }
}
