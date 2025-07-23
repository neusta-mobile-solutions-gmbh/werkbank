import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

/// {@category Werkbank Components}
class WTitled extends StatelessWidget {
  const WTitled({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle.merge(
          style: textTheme.defaultText.copyWith(color: colorScheme.text),
          overflow: TextOverflow.ellipsis,
          child: title,
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
