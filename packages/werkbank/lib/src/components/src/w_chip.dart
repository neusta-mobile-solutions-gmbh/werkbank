import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

/// {@category Werkbank Components}
class WChip extends StatelessWidget {
  const WChip({
    super.key,
    required this.onPressed,
    this.isActive = false,
    required this.label,
    this.leading,
    this.trailing,
  });

  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool isActive;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    Color textColor;
    Color trailingColor;

    if (isActive) {
      textColor = colorScheme.textActive;
      trailingColor = colorScheme.textActive;
    } else {
      textColor = colorScheme.text;
      trailingColor = colorScheme.icon;
    }

    return WButtonBase(
      semanticActiveState: true,
      onPressed: onPressed,
      isActive: isActive,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconTheme.merge(
                  data: IconThemeData(color: textColor),
                  child: leading!,
                ),
              ),
            Flexible(
              child: DefaultTextStyle.merge(
                style: context.werkbankTextTheme.indicator.apply(
                  color: textColor,
                ),
                child: label,
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconTheme.merge(
                  data: IconThemeData(color: trailingColor),
                  child: trailing!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
