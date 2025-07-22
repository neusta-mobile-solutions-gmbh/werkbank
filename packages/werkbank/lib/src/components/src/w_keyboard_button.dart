import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WKeyboardButton extends StatelessWidget {
  const WKeyboardButton({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    final textTheme = context.werkbankTextTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorScheme.chip,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: textTheme.interaction.apply(
            color: colorScheme.textLight,
          ),
        ),
      ),
    );
  }
}
