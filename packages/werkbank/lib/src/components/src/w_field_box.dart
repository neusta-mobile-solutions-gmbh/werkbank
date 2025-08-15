import 'package:flutter/material.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WFieldBox extends StatelessWidget {
  const WFieldBox({
    super.key,
    required this.child,
    this.contentPadding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.field,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: contentPadding,
        child: child,
      ),
    );
  }
}
