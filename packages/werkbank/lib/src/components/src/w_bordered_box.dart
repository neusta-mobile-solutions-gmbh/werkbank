import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WBorderedBox extends StatelessWidget {
  const WBorderedBox({
    super.key,
    required this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 2,
    required this.child,
  });

  final BorderRadius borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final halfWidth = borderWidth / 2;
    return DecoratedBox(
      position: borderColor != null
          ? DecorationPosition.foreground
          : DecorationPosition.background,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: borderColor == null ? backgroundColor : null,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth,
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(halfWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius - BorderRadius.circular(halfWidth),
            color: borderColor != null ? backgroundColor : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(halfWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
