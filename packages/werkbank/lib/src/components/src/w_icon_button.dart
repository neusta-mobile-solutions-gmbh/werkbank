import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Werkbank Components}
class WIconButton extends StatelessWidget {
  const WIconButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
    required this.icon,
    this.activeIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
  });

  final VoidCallback? onPressed;
  final bool isActive;
  final Widget icon;
  final Widget? activeIcon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    Color iconColor;
    Widget effectiveIcon;

    if (isActive) {
      iconColor = colorScheme.textActive;
      effectiveIcon = activeIcon ?? icon;
    } else {
      iconColor = colorScheme.icon;
      effectiveIcon = icon;
    }

    return WButtonBase(
      semanticActiveState: true,
      onPressed: onPressed,
      isActive: isActive,
      child: IconTheme.merge(
        data: IconThemeData(color: iconColor),
        child: Padding(
          padding: padding,
          child: effectiveIcon,
        ),
      ),
    );
  }
}
