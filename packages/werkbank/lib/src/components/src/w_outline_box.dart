import 'package:flutter/material.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WOutlineBox extends StatelessWidget {
  const WOutlineBox({
    super.key,
    required this.child,
    this.contentPadding = const EdgeInsets.all(8),
  });

  final Widget child;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.field,
          width: 2,
        ),
      ),
      child: Padding(
        padding: contentPadding,
        child: child,
      ),
    );
  }
}
