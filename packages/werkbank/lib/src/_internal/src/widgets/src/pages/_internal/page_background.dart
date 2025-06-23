import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class PageBackground extends StatelessWidget {
  const PageBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  static Color colorOf(BuildContext context) {
    return context.werkbankColorScheme.background;
  }

  @override
  Widget build(BuildContext context) {
    // Passthrough the constraints,
    // but use the maxConstraints for the background
    return ColoredBox(
      color: colorOf(context),
      child: child,
    );
  }
}
