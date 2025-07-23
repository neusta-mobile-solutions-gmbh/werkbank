import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/w_button_base.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WTrailingButton extends StatelessWidget {
  const WTrailingButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
    required this.child,
  });

  final VoidCallback? onPressed;
  final bool isActive;

  /// Consider using an [Icon] or a [Text] for the child.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    Color iconColor;
    Color textColor;

    if (isActive) {
      iconColor = colorScheme.textActive;
      textColor = colorScheme.textActive;
    } else {
      iconColor = colorScheme.icon;
      textColor = colorScheme.text;
    }

    return WButtonBase(
      semanticActiveState: true,
      onPressed: onPressed,
      isActive: isActive,
      child: IconTheme.merge(
        data: IconThemeData(color: iconColor),
        child: DefaultTextStyle.merge(
          style: context.werkbankTextTheme.textLight.apply(
            color: textColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: child,
          ),
        ),
      ),
    );
  }
}
